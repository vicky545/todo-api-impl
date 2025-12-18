%dw 2.0
output application/json
---
if (payload.affectedRows > 0) 
    (vars.deletedRecord map {
        id: $.id as String,
        title: $.title,
        (description: $.description) if (!isEmpty($.description)),
        completed: $.completed,
        dueDate: $.dueDate
    })[0]
else
    { message: "No record found to delete." }