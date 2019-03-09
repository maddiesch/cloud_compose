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
    - name: DevUserOne
      path: !Builtin iam_console_user.yml
      parameters:
        username: dev-user-one
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
  DevUserOneUserAccount:
    Type: AWS::IAM::User
    Properties:
      UserName: dev-user-one
      ManagedPolicyArns: !Ref DevUserOneManagedPolicyArnsParameter
      LoginProfile:
        Password: !FindInMap
        - DevUserOneUserAccount
        - Password
        - Value
        PasswordResetRequired: true
Parameters:
  DevUserOneManagedPolicyArnsParameter:
    Type: CommaDelimitedList
    Description: List of Managed Profile Arns.
    Default: arn:aws:iam::aws:policy/ReadOnlyAccess
Mappings:
  DevUserOneUserAccount:
    Password:
      Value: 124aa4d58a48b77b8b4397be
Outputs:
  SubTemplateOneResourceOutput:
    Value: !Ref SubTemplateOneResource
  SubTemplateTwoResourceOutput:
    Value: !Ref SubTemplateTwoResource
  DevUserOneUserAccountName:
    Value: !Ref DevUserOneUserAccount
  DevUserOneUserAccountArn:
    Value: !GetAtt
    - DevUserOneUserAccount
    - Arn
  DevUserOneUserAccountTemporaryPassword:
    Value: !FindInMap
    - DevUserOneUserAccount
    - Password
    - Value


```
