## GoStatic
GoStatic offers a fast and simple way to deploy static sites. Zero config, no cloud account needed.

https://www.gostaticapp.com/

### About the GoStatic github action
This github action allows you to easily deploy using GoStatic as part of your continuous deployment workflow.

#### Input
The input will be a directory containing your static site. This would normally be something like `./build_production` 
or `./output` etc

#### Output
The output will be a dynamically generated URL. Example: https://mmxa0g1k1hkqqreg.gostatic.app

We intend to support named subdomains and custom domains in future releases.

### Example 1 - On push, Deploy and output the URL
```yaml
on: [push]

jobs:
  hello_world_job:
    runs-on: ubuntu-latest
    name: Deploy using GoStatic
    steps:
      - uses: actions/checkout@v2
      - name: Deploy
        id: deploy
        uses: digitalsvn/gostatic@main
        with:
          api-token: ${{ secrets.GOSTATIC_API_TOKEN }}
          source-dir: './example_output_directory'

      - name: Output the deployment URL
        run: echo "URL ${{ steps.deploy.outputs.url }}"
```

### Example 2 - For open pull requests, deploy and add a comment to the relevant PR with your URL
```yaml
on: [pull_request]

jobs:
  hello_world_job:
    runs-on: ubuntu-latest
    name: Deploy using GoStatic
    steps:
      - uses: actions/checkout@v2
      - name: Deploy
        id: deploy
        uses: digitalsvn/gostatic@main
        with:
          api-token: ${{ secrets.GOSTATIC_API_TOKEN }}
          source-dir: './example_output_directory'

      - name: Output the deployment URL in a comment on the pull request
        uses: actions/github-script@0.3.0
        if: github.event_name == 'pull_request'
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          script: |
            const { issue: { number: issue_number }, repo: { owner, repo }  } = context;
            github.issues.createComment({ issue_number, owner, repo, body: 'URL ready:  ${{ steps.deploy.outputs.url }}' });
```

### Prerequisites
You will need a GoStatic API token. These are available for FREE at https://www.gostaticapp.com/

### Configuration
| Key | Example | Description | Required |
| ------------- | ------------- | ------------- | ------------- |
| `api-token` | `AAaaBBbbCCccDDddEEee` | Your GoStatic API token - this should be stored as a secret in your repo | Yes |
| `source-dir` | `./build_production` | The relative path to the directory containing the files you want to deploy | Yes |