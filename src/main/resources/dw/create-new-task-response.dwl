%dw 2.0
output application/json
var dbResult = payload // The payload currently holds the DB execution result
var originalData = vars.payload1 // Retrieve the data we saved at the start
---
{
    // 1. Get the generated ID from the DB result
    // Note: The key name might vary depending on DB (e.g., 'GENERATED_KEY', 'id', 'ID')
    id: dbResult.generatedKeys.GENERATED_KEY default null,

    // 2. Map the rest of the fields from the preserved variable
    title: originalData.title,
    (description: originalData.description) if (!isEmpty(originalData.description)),
    (completed: originalData.completed) if (!isEmpty(originalData.completed)),
    (dueDate: originalData.dueDate) if (!isEmpty(originalData.dueDate))
}