# How to use API for instructions of your program

## **Introduction**

This API allows users to calculate instructions analysis for a given input file. The calculation is performed on the server and the result is returned to the user in the form of a JSON object.

## **Endpoint**

The endpoint for this API is **`instructions.pythonanywhere.com/instructions_api`** . The API only supports the **`POST`** method.

## **Request Body**

The request body should be in **`multipart/form-data`** format, with the following fields:

- **`file`** (required): The file to be used as input for the calculation. The file should be in a format supported by the calculation engine.

Example of how to send a file in a **`multipart/form-data`** request in curl:

```

curl -X POST https://instructions.pythonanywhere.com/instructions_api -H 'Content-Type: multipart/form-data' -F 'file=@/path/to/file'

```

## **Response**

The response will be in the following format:

```
{
  "Chart": "link",
  "Instruction": "link",
  "analysis": "link"
}
```

- **`status`**: The status of the calculation. Can be "success" or "error".
- **`result`**: If the status is "success", this field will contain the result of the calculation. If the status is "error", this field will contain an error message.

## **Example**

For this example program hello is present on the current directory.

```
curl -X POST https://instructions.pythonanywhere.com/instructions_api -H 'Content-Type: multipart/form-data' -F 'file=@hello'
```

```
{
  "Chart": "https://instructions.pythonanywhere.com//home/instructions/dic/static/dic_temp_files/hello_chart",
  "Instruction": "https://instructions.pythonanywhere.com//home/instructions/dic/static/dic_temp_files/hello_ins",
  "analysis": "https://instructions.pythonanywhere.com//home/instructions/dic/static/dic_temp_files/hello_analysis"
}

```

## **Errors**

- **`400 Bad Request`**: The request body is missing or improperly formatted.
- **`404 Not Found`**: The file provided in the request was not found.
- **`415 Unsupported Media Type`**: The file provided in the request is in an unsupported format.
- **`500 Internal Server Error`**: An error occurred on the server while processing the calculation.

It's worth to note that for security reasons and best practices it is important to validate and sanitize the file input, Also you need to consider the file size, format, and storage limits.

This documentation should give you an idea of how to use this API for calculating instructions using a file as input.