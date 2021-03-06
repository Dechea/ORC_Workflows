# ORC_Workflows

We manage our continuous deployment workflows centrally, so that every team can focus as most as possible on outcome instead on managing operation stuff.

We have different reusable workflows for every repository type, that covers the repository specific stuff. You find more information about it in [Miro](https://miro.com/app/board/o9J_lY7KxM0=/?moveToWidget=3458764521960752239&cot=14).

## Frontend - Serverless cloud
TBD

## Functions - Serverless cloud

[Link to Workflow](https://github.com/Dechea/ORC_Workflows/blob/main/.github/workflows/continuousDeploymentServerless.yml)

Embed the following code and change inside the "Deploy" job the following props based on your Domain:
<ul>
  <li>PROD_INSTANCES</li>
  <li>MUTATION_TEST</li>
</ul>

```yaml
name: Continuous Deployment
on:
  push:
  workflow_dispatch:
jobs:
  Deploy:
    uses: Dechea/ORC_Workflows/.github/workflows/continuousDeploymentServerless.yml@main
    with:
      PROD_INSTANCES: "prod"
      MUTATION_TEST: "false"
    secrets:
      SERVERLESS_TOKEN: ${{ secrets.SERVERLESS_TOKEN }}
      BIT_TOKEN: ${{ secrets.BIT_TOKEN }}
```

## IaC - Fauna

[Link to Workflow](https://github.com/Dechea/ORC_Workflows/blob/main/.github/workflows/continuousDeploymentFauna.yml)

Embed the following code and change inside the "DeployDev" job the following props and secrets based on your Domain:
<ul>
  <li>FAUNA_DATABASE</li>
  <li>FAUNA_TOKEN</li>
  <li>SONAR_TOKEN_SCHEMA (DEPRECATED)</li>
</ul>

```yaml
jobs:
  DeployDev:
    if: github.event_name == 'pull_request' || github.ref != 'refs/heads/main'
    uses: Dechea/ORC_Workflows/.github/workflows/continuousDeploymentFauna.yml@main
    with:
      FAUNA_DATABASE: 'USR_User' #CHANGE THIS VALUE TO YOUR DOMAIN/DEV DATABASE
      MUTATION_TEST: true
    secrets:
      GITHUB_PAT: ${{ secrets.SCHEMA_PAT_GITHUB }}
      FAUNA_REGION: ${{ secrets.FAUNA_REGION }}
      FAUNA_TOKEN: ${{ secrets.FAUNA_TOKEN_USR }} #CHANGE THIS VALUE TO YOUR FAUNA_TOKEN_xy
      FAUNA_CHILD_DB: ${{ secrets.FAUNA_TOKEN_UNIT_INTEGRATION_TESTING }}
      SONAR_TOKEN_SCHEMA: ${{ secrets.SONAR_TOKEN_USR_SCHEMA }} #CHANGE THIS VALUE TO YOUR SONAR_TOKEN_xy_SCHEMA (DEPRECATED)

  DeployProduction:
    if: github.ref == 'refs/heads/main'
    uses: Dechea/ORC_Workflows/.github/workflows/continuousDeploymentFauna.yml@main
    with:
      FAUNA_DATABASE: 'Production'
      MUTATION_TEST: false
    secrets:
      GITHUB_PAT: ${{ secrets.SCHEMA_PAT_GITHUB }}
      FAUNA_REGION: ${{ secrets.FAUNA_REGION }}
      FAUNA_TOKEN: ${{ secrets.FAUNA_TOKEN_PRODUCTION }}
      FAUNA_CHILD_DB: ${{ secrets.FAUNA_TOKEN_UNIT_INTEGRATION_TESTING }}
      SONAR_TOKEN_SCHEMA: ${{ secrets.SONAR_TOKEN_USR_SCHEMA }} #CHANGE THIS VALUE TO YOUR SONAR_TOKEN_xy_SCHEMA (DEPRECATED)
```

## Components - Bit

[Link to Workflow](https://github.com/Dechea/ORC_Workflows/blob/main/.github/workflows/continuousDeploymentBit.yml)

Embed the following code and change inside the "Deploy" job the following props based on your Domain:
<ul>
  <li>SCOPE_NAME</li>
</ul>

```yaml
name: Continuous Deployment
on:
  push:
    branches-ignore:
        - 'main'
  pull_request:
    types:
      [closed]
  workflow_dispatch:

jobs:
  Deploy:
    uses: Dechea/ORC_Workflows/.github/workflows/continuousDeploymentBit.yml@main
    secrets:
      BIT_TOKEN: ${{ secrets.BIT_TOKEN }}
```
