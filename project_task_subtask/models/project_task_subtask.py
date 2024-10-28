from markupsafe import Markup

from odoo import api, fields, models
from odoo.exceptions import UserError
from odoo.tools.translate import _

SUBTASK_STATES = {
    "done": "Done",
    "todo": "TODO",
    "waiting": "Waiting",
    "cancelled": "Cancelled",
}


class ProjectTaskSubtask(models.Model):
    _name = "project.task.subtask"
    _description = "Subtask"
    _inherit = ["mail.activity.mixin"]
    state = fields.Selection(
        [(k, v) for k, v in list(SUBTASK_STATES.items())],
        "Status",
        required=True,
        copy=False,
        default="todo",
    )
    name = fields.Char(required=True, string="Description")
    reviewer_id = fields.Many2one(
        "res.users", "Reviewer", readonly=True, default=lambda self: self.env.user
    )
    project_id = fields.Many2one(
        "project.project", related="task_id.project_id", store=True
    )
    user_id = fields.Many2one("res.users", "Assigned to", required=True)
    task_id = fields.Many2one(
        "project.task", "Task", ondelete="cascade", required=True, index=True
    )
    task_state = fields.Char(
        string="Task state", related="task_id.stage_id.name", readonly=True
    )
    hide_button = fields.Boolean(compute="_compute_hide_button")
    recolor = fields.Boolean(compute="_compute_recolor")
    deadline = fields.Datetime()

    def _compute_recolor(self):
        for record in self:
            record.recolor = (
                True
                if self.env.user == record.user_id and record.state == "todo"
                else False
            )

    def _compute_hide_button(self):
        for record in self:
            record.hide_button = self.env.user not in [
                record.reviewer_id,
                record.user_id,
            ]

    def _compute_reviewer_id(self):
        for record in self:
            record.reviewer_id = record.create_uid

    @api.model
    def _needaction_domain_get(self):
        if self._needaction:
            return [("state", "=", "todo"), ("user_id", "=", self.env.uid)]
        return []

    def write(self, vals):
        old_names = dict(list(zip(self.mapped("id"), self.mapped("name"))))
        result = super(ProjectTaskSubtask, self).write(vals)
        for r in self:
            if vals.get("state"):
                r.task_id.send_subtask_email(
                    r.name, r.state, r.reviewer_id.id, r.user_id.id
                )
                if self.env.user != r.reviewer_id and self.env.user != r.user_id:
                    raise UserError(
                        _("Only users related to that subtask can change state.")
                    )
            if vals.get("name"):
                r.task_id.send_subtask_email(
                    r.name,
                    r.state,
                    r.reviewer_id.id,
                    r.user_id.id,
                    old_name=old_names[r.id],
                )
                if self.env.user != r.reviewer_id and self.env.user != r.user_id:
                    raise UserError(
                        _("Only users related to that subtask can change state.")
                    )
            if vals.get("user_id"):
                r.task_id.send_subtask_email(
                    r.name, r.state, r.reviewer_id.id, r.user_id.id
                )
        return result

    @api.model
    def create(self, vals):
        result = super(ProjectTaskSubtask, self).create(vals)
        vals = self._add_missing_default_values(vals)
        task = self.env["project.task"].browse(vals.get("task_id"))
        task.send_subtask_email(
            vals["name"], vals["state"], vals["reviewer_id"], vals["user_id"]
        )
        return result

    def change_state_done(self):
        for record in self:
            record.state = "done"

    def change_state_todo(self):
        for record in self:
            record.state = "todo"

    def change_state_cancelled(self):
        for record in self:
            record.state = "cancelled"

    def change_state_waiting(self):
        for record in self:
            record.state = "waiting"


class Task(models.Model):
    _inherit = "project.task"
    subtask_ids = fields.One2many("project.task.subtask", "task_id", "Subtask")
    kanban_subtasks = fields.Html(compute="_compute_kanban_subtasks")
    default_user = fields.Many2one("res.users", compute="_compute_default_user")
    completion = fields.Integer(compute="_compute_completion")
    completion_xml = fields.Html(compute="_compute_completion_xml")

    def _compute_default_user(self):
        for record in self:
            if len(record.user_ids) <= 1:
                if (
                    self.env.user != record.user_ids
                    and self.env.user != record.create_uid
                ):
                    record.default_user = record.user_ids
                else:
                    if self.env.user != record.user_ids:
                        record.default_user = record.user_ids
                    elif self.env.user != record.create_uid:
                        record.default_user = record.create_uid
                    elif (
                        self.env.user == record.create_uid
                        and self.env.user == record.user_ids
                    ):
                        record.default_user = self.env.user
            else:
                record.default_user = False

    def _compute_kanban_subtasks(self):
        for record in self:
            result_string_td = Markup("")
            result_string_wt = Markup("")
            if record.subtask_ids:
                task_todo_ids = record.subtask_ids.filtered(
                    lambda x: x.state == "todo" and x.user_id.id == record.env.user.id
                )
                task_waiting_ids = record.subtask_ids.filtered(
                    lambda x: x.state == "waiting"
                    and x.user_id.id == record.env.user.id
                )
                if task_todo_ids:
                    result_string_td += Markup(
                        f"<li><b>TODO: {len(task_todo_ids)}</b></li>"
                    )
                if task_waiting_ids:
                    result_string_wt += Markup(
                        f"<li><b>Waiting: {len(task_waiting_ids)}</b></li>"
                    )
            record.kanban_subtasks = (
                Markup('<div class="kanban_subtasks"><ul>')
                + result_string_td
                + result_string_wt
                + Markup("</ul></div>")
            )

    def _compute_completion(self):
        for record in self:
            record.completion = record.task_completion()

    def _compute_completion_xml(self):
        for record in self:
            active_subtasks = record.subtask_ids and record.subtask_ids.filtered(
                lambda x: x.user_id.id == record.env.user.id and x.state != "cancelled"
            )
            if not active_subtasks:
                record.completion_xml = Markup(
                    """
                    <div class="task_progress">
                    </div>
                """
                )
                continue

            completion = record.task_completion()
            color = "bg-success-full"
            if completion < 50:
                color = "bg-danger-full"
            record.completion_xml = Markup(
                """
            <div class="task_progress">
                <div class="progress_info">
                    Your Checklist:
                </div>
                <div class ="o_kanban_counter_progress progress task_progress_bar">
                    <div data-filter="done"
                         class ="progress-bar {1} o_bar_has_records task_progress_bar_done"
                         data-original-title="1 done"
                         style="width: {0}%;">
                    </div>
                    <div data-filter="blocked"
                         class ="progress-bar bg-danger-full"
                         data-original-title="0 blocked">
                    </div>
                </div>
                <div class="task_completion"> {0}% </div>
            </div>
            """.format(
                    int(completion), color
                )
            )

    def task_completion(self):
        user_task_ids = self.subtask_ids.filtered(
            lambda x: x.user_id.id == self.env.user.id and x.state != "cancelled"
        )
        if not user_task_ids:
            return 100
        user_done_task_ids = user_task_ids.filtered(lambda x: x.state == "done")
        return (len(user_done_task_ids) / len(user_task_ids)) * 100

    def send_subtask_email(
        self,
        subtask_name,
        subtask_state,
        subtask_reviewer_id,
        subtask_user_id,
        old_name=None,
    ):
        state = Markup(SUBTASK_STATES[subtask_state])

        if subtask_state == "done":
            state = Markup('<span style="color:#080')
