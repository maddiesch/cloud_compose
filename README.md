# CloudCompose

Compose multiple cloud formation templates into one file.

`cloud-compose build ./template.yml ./output`

```yaml
# template.yml
---
$cloud_compose:
  parameters:
    GlobalName: 'TestTemplate'
  imports:
    - name: SubTemplateOne
      path: ./sub_readme.yml
    - name: SubTemplateTwo
      path: ./sub_readme.yml
---

Resources:
  $(GlobalName)MainResource:
    Type: AWS::Fake::Thing
    Properties:
      Name: My Main Resource
  SecondaryResource:
    Type: AWS::Fake::Thing
    Properties:
      ParentThing: !Ref $(GlobalName)MainResource
```

```yaml
# sub_readme.yml
---
$cloud_compose:
  partial: true
---

Resources:
  $(name)Resource:
    Type: AWS::Fake::Thing
    Properties:
      ParentThing: !Ref $(GlobalName)MainResource
Outputs:
  $(name)ResourceOutput:
    Value: !Ref $(name)Resource

```

```yaml
# Output
---
Resources:
  TestTemplateMainResource:
    Type: AWS::Fake::Thing
    Properties:
      Name: My Main Resource
  SecondaryResource:
    Type: AWS::Fake::Thing
    Properties:
      ParentThing: !Ref TestTemplateMainResource
  SubTemplateOneResource:
    Type: AWS::Fake::Thing
    Properties:
      ParentThing: !Ref TestTemplateMainResource
  SubTemplateTwoResource:
    Type: AWS::Fake::Thing
    Properties:
      ParentThing: !Ref TestTemplateMainResource
Outputs:
  SubTemplateOneResourceOutput:
    Value: !Ref SubTemplateOneResource
  SubTemplateTwoResourceOutput:
    Value: !Ref SubTemplateTwoResource
```
