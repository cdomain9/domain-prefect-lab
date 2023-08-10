from prefect.filesystems import GitHub
import os

gh_repo = GitHub(
    repository="https://github.com/analytics8/prefect-dbt-starter",
    access_token=os.environ.get("GITHUB_TOKEN")
)
gh_repo.save("github-repo", overwrite=True)
