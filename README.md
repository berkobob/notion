* Notion Database API
Create, edit, read and delete entries in a specified Notion database
Retrieve list of relation database links

** Setup
Environment variables
```json
    "env": {
        "TOKEN": 'Notion API Token',
        "DATABASE": 'Notion database ID',
        "PROJECTS": 'Notion project database ID'
    }
```

** Todo
- Allow adding and getting notes as Page Blocks
  
`patch: https://api.notion.com/v1/blocks/<Todo ID>/children`

```
{
  "children": [
    {
      "paragraph": {
        "rich_text": [
          {
            "type": "text",
            "text": {
              "content": "will this work"
            }
          }
          ]
      }
    }
    ]
}
```