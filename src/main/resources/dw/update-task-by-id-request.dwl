%dw 2.0
output application/java

// 1. Capture the ID from URI Params (convert to Number if your DB expects an int)
var taskId = attributes.uriParams.taskId

// 2. Define potential columns to update
// The syntax (key: value) if (condition) automatically removes the key if the condition is false
var columnsToUpdate = {
    (completed: payload.completed) if (payload.completed != null),
    (dueDate:   payload.dueDate)   if (payload.dueDate != null),
    (title:     payload.title)     if (payload.title != null),
    (description: payload.description) if (payload.description != null)
}

// 3. Construct the SET clause
// pluck turns the object into an array of strings: ["completed = :completed", "dueDate = :dueDate"]
// joinBy combines them with commas
var setClause = columnsToUpdate pluck ((value, key) -> "$(key) = :$(key)") joinBy ", "

---
{
    // WARNING: This string will be invalid if setClause is empty (i.e., no fields to update)
    sqlText: "UPDATE tasks SET " ++ setClause ++ " WHERE id = :myId",
    
    // Merge the update fields with the ID parameter
    params: columnsToUpdate ++ { myId: taskId }
}