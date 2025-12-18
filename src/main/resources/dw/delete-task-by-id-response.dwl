%dw 2.0
output application/json
---
vars.deletedRecord map {
        id: $.id as String,
        title: $.title,
        (description: $.description) if (!isEmpty($.description)),
        completed: $.completed,
        dueDate: $.dueDate
    }