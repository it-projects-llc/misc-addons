[33mcommit 32dff064ec234e2a458f7b9a2661893c14bef4e1[m[33m ([m[1;36mHEAD[m[33m -> [m[1;32m17.0-mig2-project_task_subtask[m[33m, [m[1;31mMedeeet/17.0-mig2-project_task_subtask[m[33m)[m
Author: Medet <zhumakhanmedet@gmail.com>
Date:   Fri Oct 4 13:22:33 2024 +0500

    [IMP] project_task_subtask: pre-commit auto fixes

[1mdiff --git a/project_task_subtask/README.rst b/project_task_subtask/README.rst[m
[1mindex dc23d21..4182df7 100644[m
[1m--- a/project_task_subtask/README.rst[m
[1m+++ b/project_task_subtask/README.rst[m
[36m@@ -17,7 +17,7 @@[m [mProject Task Checklist[m
     :target: http://www.gnu.org/licenses/lgpl-3.0-standalone.html[m
     :alt: License: LGPL-3[m
 .. |badge3| image:: https://img.shields.io/badge/github-it--projects--llc%2Fmisc--addons-lightgray.png?logo=github[m
[31m-    :target: https://github.com/it-projects-llc/misc-addons/tree/15.0/project_task_subtask[m
[32m+[m[32m    :target: https://github.com/it-projects-llc/misc-addons/tree/17.0/project_task_subtask[m
     :alt: it-projects-llc/misc-addons[m
 [m
 |badge1| |badge2| |badge3|[m
[36m@@ -85,7 +85,7 @@[m [mBug Tracker[m
 Bugs are tracked on `GitHub Issues <https://github.com/it-projects-llc/misc-addons/issues>`_.[m
 In case of trouble, please check there if your issue has already been reported.[m
 If you spotted it first, help us to smash it by providing a detailed and welcomed[m
[31m-`feedback <https://github.com/it-projects-llc/misc-addons/issues/new?body=module:%20project_task_subtask%0Aversion:%2015.0%0A%0A**Steps%20to%20reproduce**%0A-%20...%0A%0A**Current%20behavior**%0A%0A**Expected%20behavior**>`_.[m
[32m+[m[32m`feedback <https://github.com/it-projects-llc/misc-addons/issues/new?body=module:%20project_task_subtask%0Aversion:%2017.0%0A%0A**Steps%20to%20reproduce**%0A-%20...%0A%0A**Current%20behavior**%0A%0A**Expected%20behavior**>`_.[m
 [m
 Do not contact contributors directly about support or help with technical issues.[m
 [m
[36m@@ -115,6 +115,6 @@[m [mContributors[m
 Maintainers[m
 -----------[m
 [m
[31m-This module is part of the `it-projects-llc/misc-addons <https://github.com/it-projects-llc/misc-addons/tree/15.0/project_task_subtask>`_ project on GitHub.[m
[32m+[m[32mThis module is part of the `it-projects-llc/misc-addons <https://github.com/it-projects-llc/misc-addons/tree/17.0/project_task_subtask>`_ project on GitHub.[m
 [m
 You are welcome to contribute.[m
[1mdiff --git a/project_task_subtask/__manifest__.py b/project_task_subtask/__manifest__.py[m
[1mindex 18d9de9..d5f2566 100644[m
[1m--- a/project_task_subtask/__manifest__.py[m
[1m+++ b/project_task_subtask/__manifest__.py[m
[36m@@ -3,7 +3,7 @@[m
     "summary": """Use checklist to be ensure that all your tasks are performed and to make easy control over them""",  # noqa: B950[m
     "category": """Project Management""",[m
     "images": ["images/checklist_main.png"],[m
[31m-    "version": "15.0.1.0.0",[m
[32m+[m[32m    "version": "17.0.1.0.0",[m
     "author": "IT-Projects LLC",[m
     "support": "it@it-projects.info",[m
     "website": "https://github.com/it-projects-llc/misc-addons",[m
[36m@@ -17,8 +17,6 @@[m
     "assets": {[m
         "web.assets_backend": [[m
             "/project_task_subtask/static/src/css/kanban_styles.css",[m
[31m-            "/project_task_subtask/static/src/js/one2many_renderer.js",[m
[31m-            "/project_task_subtask/static/src/js/tours/tour.js",[m
         ],[m
         "web.assets_qweb": [[m
             "/project_task_subtask/static/src/xml/templates.xml",[m
[1mdiff --git a/project_task_subtask/pyproject.toml b/project_task_subtask/pyproject.toml[m
[1mnew file mode 100644[m
[1mindex 0000000..4231d0c[m
[1m--- /dev/null[m
[1m+++ b/project_task_subtask/pyproject.toml[m
[36m@@ -0,0 +1,3 @@[m
[32m+[m[32m[build-system][m
[32m+[m[32mrequires = ["whool"][m
[32m+[m[32mbuild-backend = "whool.buildapi"[m
[1mdiff --git a/project_task_subtask/static/src/js/one2many_renderer.js b/project_task_subtask/static/src/js/one2many_renderer.js[m
[1mdeleted file mode 100644[m
[1mindex ce12f02..0000000[m
[1m--- a/project_task_subtask/static/src/js/one2many_renderer.js[m
[1m+++ /dev/null[m
[36m@@ -1,219 +0,0 @@[m
[31m-odoo.define("project_task_subtask.one2many_renderer", function (require) {[m
[31m-    "use strict";[m
[31m-    var FieldOne2Many = require("web.relational_fields").FieldOne2Many;[m
[31m-    var BasicModel = require("web.BasicModel");[m
[31m-[m
[31m-    var core = require("web.core");[m
[31m-    var QWeb = core.qweb;[m
[31m-[m
[31m-    FieldOne2Many.include({[m
[31m-        check_task_tree_mode: function () {[m
[31m-            if ([m
[31m-                this.view &&[m
[31m-                this.view.arch.tag === "tree" &&[m
[31m-                this.record &&[m
[31m-                this.record.model === "project.task" &&[m
[31m-                this.name === "subtask_ids"[m
[31m-            ) {[m
[31m-                return true;[m
[31m-            }[m
[31m-            return false;[m
[31m-        },[m
[31m-[m
[31m-        sort_data: function () {[m
[31m-            var user_id = this.record.context.uid;[m
[31m-[m
[31m-            var new_rows = _.filter(this.value.data, function (d) {[m
[31m-                return !d.res_id;[m
[31m-            });[m
[31m-            var data = _.difference(this.value.data, new_rows);[m
[31m-[m
[31m-            _.each(data, function (d) {[m
[31m-                d.u_name = d.data.user_id.data.display_name;[m
[31m-            });[m
[31m-[m
[31m-            var name_index = _.sortBy([m
[31m-                _.uniq([m
[31m-                    _.map(data, function (d) {[m
[31m-                        return d.data.user_id.data.display_name;[m
[31m-                    })[m
[31m-                )[m
[31m-            );[m
[31m-[m
[31m-            data = _.sortBy(data, "u_name");[m
[31m-            _.each(data, function (d) {[m
[31m-                d.deadline = d.data.deadline;[m
[31m-                if (d.data.user_id.data.id === user_id) {[m
[31m-                    d.index = 0;[m
[31m-                } else {[m
[31m-                    d.index =[m
[31m-                        (_.indexOf(name_index, d.data.user_id.data.display_name) + 1) *[m
[31m-                        1000000;[m
[31m-                }[m
[31m-            });[m
[31m-[m
[31m-            data = _.sortBy(data, "deadline");[m
[31m-            _.each(data, function (d) {[m
[31m-                d.index += _.indexOf(data, d);[m
[31m-                if (!d.deadline) {[m
[31m-                    d.index += 90000;[m
[31m-                }[m
[31m-                if (d.data.state === "todo") {[m
[31m-                    // Continue[m
[31m-                } else if (d.data.state === "waiting") {[m
[31m-                    d.index += 100000;[m
[31m-                } else if (d.data.state === "done") {[m
[31m-                    d.index += 400000;[m
[31m-                } else {[m
[31m-                    // Makes cancelled subtasks stay last in line[m
[31m-                    d.index += (name_index.length + 2) * 1000000;[m
[31m-                    if (d.data.user_id.data.id !== user_id) {[m
[31m-                        d.index +=[m
[31m-                            (_.indexOf(name_index, d.data.user_id.data.display_name) +[m
[31m-                                1) *[m
[31m-                            1000000;[m
[31m-                    }[m
[31m-                }[m
[31m-            });[m
[31m-            data = _.sortBy(data, "index");[m
[31m-            _.each(new_rows, function (r) {[m
[31m-                data.push(r);[m
[31m-            });[m
[31m-            this.default_sorting = this.value.data;[m
[31m-            this.value.data = data;[m
[31m-        },[m
[31m-[m
[31m-        _render: function () {[m
[31m-            if (this.check_task_tree_mode() && this.getParent().list_is_sorted) {[m
[31m-                this.sort_data();[m
[31m-            }[m
[31m-            return this._super(arguments);[m
[31m-        },[m
[31m-[m
[31m-        reset: function (record, ev, fieldChanged) {[m
[31m-            var self = this;[m
[31m-            return this._super.apply(this, arguments).then(function (res) {[m
[31m-                if (self.check_task_tree_mode() && self.getParent().list_is_sorted) {[m
[31m-                    self._render();[m
[31m-                }[m
[31m-            });[m
[31m-        },[m
[31m-[m
[31m-        _renderButtons: function () {[m
[31m-            var self = this;[m
[31m-            if (this.check_task_tree_mode()) {[m
[31m-                this.$buttons = $([m
[31m-                    QWeb.render("SubtaskSortButtons", {[m
[31m-                        check_button: this.getParent().list_is_sorted,[m
[31m-                    })[m
[31m-                );[m
[31m-                this.$buttons.on([m
[31m-                    "click",[m
[31m-                    ".o_pager_sort",[m
[31m-                    this._update_custom_sort_buttons.bind(this)[m
[31m-                );[m
[31m-                this.$buttons.on([m
[31m-                    "click",[m
[31m-                    ".o_pager_unsort",[m
[31m-                    this._update_custom_unsort_buttons.bind(this)[m
[31m-                );[m
[31m-            }[m
[31m-            return this._super(arguments);[m
[31m-        },[m
[31m-[m
[31m-        _update_custom_sort_buttons: function () {[m
[31m-            this.getParent().list_is_sorted = true;[m
[31m-            this.default_sorting = this.value.data;[m
[31m-            this._render();[m
[31m-        },[m
[31m-[m
[31m-        _update_custom_unsort_buttons: function () {[m
[31m-            this.getParent().list_is_sorted = false;[m
[31m-            this.value.data = this.default_sorting;[m
[31m-            this._render();[m
[31m-        },[m
[31m-    });[m
[31m-[m
[31m-    BasicModel.include({[m
[31m-        _sortList: function (list) {[m
[31m-            // Taken from odoo[m
[31m-            if (!list.static) {[m
[31m-                // Only sort x2many lists[m
[31m-                return;[m
[31m-            }[m
[31m-            var self = this;[m
[31m-            // -----[m
[31m-[m
[31m-            if (list.model === "project.task.subtask" && list.orderedResIDs) {[m
[31m-                var rows = [];[m
[31m-                var new_rows = [];[m
[31m-                _.each(list.data, function (d) {[m
[31m-                    var r = self.localData[d];[m
[31m-                    if (Number(r.res_id) === r.res_id) {[m
[31m-                        rows.push(r);[m
[31m-                    } else {[m
[31m-                        new_rows.push(r);[m
[31m-                    }[m
[31m-                });[m
[31m-                rows = this.sort_data(rows, list.context.uid, this);[m
[31m-                _.each(new_rows, function (r) {[m
[31m-                    rows.push(r);[m
[31m-                });[m
[31m-                list.orderedResIDs = _.pluck(rows, "res_id");[m
[31m-                return this._setDataInRange(list);[m
[31m-            }[m
[31m-[m
[31m-            return this._super(list);[m
[31m-        },[m
[31m-[m
[31m-        sort_data: function (data, user_id, parent) {[m
[31m-            user_id = user_id || 1;[m
[31m-[m
[31m-            _.each(data, function (d) {[m
[31m-                d.u_name = parent.localData[d.data.user_id].data.display_name;[m
[31m-            });[m
[31m-[m
[31m-            var name_index = _.sortBy([m
[31m-                _.uniq([m
[31m-                    _.map(data, function (d) {[m
[31m-                        return parent.localData[d.data.user_id].data.display_name;[m
[31m-                    })[m
[31m-                )[m
[31m-            );[m
[31m-[m
[31m-            data = _.sortBy(data, "u_name");[m
[31m-            _.each(data, function (d) {[m
[31m-                d.deadline = d.data.deadline;[m
[31m-                if (parent.localData[d.data.user_id].data.id === user_id) {[m
[31m-                    d.index = 0;[m
[31m-                } else {[m
[31m-                    d.index =[m
[31m-                        (_.indexOf([m
[31m-                            name_index,[m
[31m-                            parent.localData[d.data.user_id].data.display_name[m
[31m-                        ) +[m
[31m-                            1) *[m
[31m-                        1000000;[m
[31m-                }[m
[31m-            });[m
[31m-[m
[31m-            data = _.sortBy(data, "deadline");[m
[31m-            _.each(data, function (d) {[m
[31m-                d.index += _.indexOf(data, d);[m
[31m-                if (!d.deadline) {[m
[31m-                    d.index += 90000;[m
[31m-                }[m
[31m-                if (d.data.state === "todo") {[m
[31m-                    // Continue[m
[31m-                } else if (d.data.state === "waiting") {[m
[31m-                    d.index += 100000;[m
[31m-                } else if (d.data.state === "done") {[m
[31m-                    d.index += 400000;[m
[31m-                } else {[m
[31m-                    d.index += 700000;[m
[31m-                }[m
[31m-            });[m
[31m-            return _.sortBy(data, "index");[m
[31m-        },[m
[31m-    });[m
[31m-});[m
[1mdiff --git a/project_task_subtask/static/src/js/tours/tour.js b/project_task_subtask/static/src/js/tours/tour.js[m
[1mdeleted file mode 100644[m
[1mindex c898566..0000000[m
[1m--- a/project_task_subtask/static/src/js/tours/tour.js[m
[1m+++ /dev/null[m
[36m@@ -1,60 +0,0 @@[m
[31m-odoo.define("project_task_subtask.tour", function (require) {[m
[31m-    "use strict";[m
[31m-[m
[31m-    var core = require("web.core");[m
[31m-    var tour = require("web_tour.tour");[m
[31m-[m
[31m-    var _t = core._t;[m
[31m-[m
[31m-    var steps = [[m
[31m-        tour.stepUtils.showAppsMenuItem(),[m
[31m-        {[m
[31m-            trigger: '.o_app[data-menu-xmlid="project.menu_main_pm"]',[m
[31m-            content: _t([m
[31m-                "Want a better way to <b>manage your projects</b>? <i>It starts here.</i>"[m
[31m-            ),[m
[31m-            position: "right",[m
[31m-            edition: "community",[m
[31m-        },[m
[31m-        {[m
[31m-            trigger: '.o_app[data-menu-xmlid="project.menu_main_pm"]',[m
[31m-            content: _t([m
[31m-                "Want a better way to <b>manage your projects</b>? <i>It starts here.</i>"[m
[31m-            ),[m
[31m-            position: "bottom",[m
[31m-            edition: "enterprise",[m
[31m-        },[m
[31m-        {[m
[31m-            trigger: ".o_project_kanban_main",[m
[31m-            content: "open project",[m
[31m-            timeout: 10000,[m
[31m-        },[m
[31m-        {[m
[31m-            trigger: ".o_loading",[m
[31m-            content: "waiting for loading to finish",[m
[31m-            timeout: 5000,[m
[31m-        },[m
[31m-        {[m
[31m-            trigger: ".o_content",[m
[31m-            content: "just click",[m
[31m-            timeout: 1000,[m
[31m-        },[m
[31m-        {[m
[31m-            trigger: ".o_kanban_project_tasks .oe_kanban_content",[m
[31m-            content: "open task",[m
[31m-            timeout: 20000,[m
[31m-        },[m
[31m-        {[m
[31m-            trigger: ".o_pager_sort",[m
[31m-            content: "sort",[m
[31m-            timeout: 10000,[m
[31m-        },[m
[31m-        {[m
[31m-            trigger: ".o_pager_unsort",[m
[31m-            content: "unsort",[m
[31m-            timeout: 10000,[m
[31m-        },[m
[31m-    ];[m
[31m-[m
[31m-    tour.register("task_subtask", {url: "/web"}, steps);[m
[31m-});[m
[1mdiff --git a/project_task_subtask/static/src/xml/templates.xml b/project_task_subtask/static/src/xml/templates.xml[m
[1mdeleted file mode 100644[m
[1mindex 7a61354..0000000[m
[1m--- a/project_task_subtask/static/src/xml/templates.xml[m
[1m+++ /dev/null[m
[36m@@ -1,23 +0,0 @@[m
[31m-<?xml version="1.0" encoding="utf-8" ?>[m
[31m-<template xml:space="preserve">[m
[31m-    <t t-name="SubtaskSortButtons">[m
[31m-        <div>[m
[31m-            <button[m
[31m-                aria-label="Sort"[m
[31m-                class="btn btn-sm btn-primary o_pager_sort"[m
[31m-                type="button"[m
[31m-                t-if="!check_button"[m
[31m-            >[m
[31m-                Sort[m
[31m-            </button>[m
[31m-            <button[m
[31m-                aria-label="Unsort"[m
[31m-                class="btn btn-sm btn-default o_pager_unsort"[m
[31m-                type="button"[m
[31m-                t-if="check_button"[m
[31m-            >[m
[31m-                Unsort[m
[31m-            </button>[m
[31m-        </div>[m
[31m-    </t>[m
[31m-</template>[m
[1mdiff --git a/project_task_subtask/tests/__init__.py b/project_task_subtask/tests/__init__.py[m
[1mdeleted file mode 100644[m
[1mindex 027ead8..0000000[m
[1m--- a/project_task_subtask/tests/__init__.py[m
[1m+++ /dev/null[m
[36m@@ -1,3 +0,0 @@[m
[31m-# License MIT (https://opensource.org/licenses/MIT).[m
[31m-[m
[31m-from . import test_subtask_sort_button[m
[1mdiff --git a/project_task_subtask/tests/test_subtask_sort_button.py b/project_task_subtask/tests/test_subtask_sort_button.py[m
[1mdeleted file mode 100644[m
[1mindex 4bfbc6f..0000000[m
[1m--- a/project_task_subtask/tests/test_subtask_sort_button.py[m
[1m+++ /dev/null[m
[36m@@ -1,9 +0,0 @@[m
[31m-import odoo.tests[m
[31m-[m
[31m-[m
[31m-class TestUi(odoo.tests.HttpCase):[m
[31m-    def test_01_subtask_sort_button(self):[m
[31m-        self.env["ir.module.module"].search([m
[31m-            [("name", "=", "project_task_subtask")], limit=1[m
[31m-        ).state = "installed"[m
[31m-        self.start_tour("/web", "task_subtask", login="admin")[m
