%dw 2.0
output application/java
// 1. Filter out nulls to create a clean object
var cleanPayload = payload filterObject ($ != null)

// 2. dynamically generate the column names
var columns = keysOf(cleanPayload) joinBy ", "

// 3. dynamically generate the parameter placeholders (e.g., :title, :desc)
var params = keysOf(cleanPayload) map (":" ++ $) joinBy ", "
---
{
    // The query string with placeholders
    query: "INSERT INTO tasks (" ++ columns ++ ") VALUES (" ++ params ++ ")",
    
    // The actual values map
    inputParams: cleanPayload
}