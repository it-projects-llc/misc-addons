#
#
#    OpenERP, Open Source Management Solution
#    Copyright (C) 2013 Julius Network Solutions SARL <contact@julius.fr>
#    Copyright (C) 2015 credativ ltd. <info@credativ.co.uk>
#    Copyright (c) 2019 Matteo Bilotta <mbilotta@linkgroup.it>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#

{
    "name": "Product Tags",
    "version": "12.0.1.1.0",
    "author": "Julius Network Solutions",
    "website": "http://julius.fr",
    "category": "Sales",
    "depends": [
        'product',
        'sale'
    ],
    'license': 'AGPL-3',
    "data": [
        'security/ir.model.access.csv',

        'views/product_tag_view.xml',
        'views/product_template_view.xml'
    ]
}
