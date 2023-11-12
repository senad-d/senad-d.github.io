---
title: Super-Linter
date: 2023-11-12 12:00:00
categories: [Software, GitHub]
tags: [github, actions, linter, locally]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/git-banner.png?raw=true){: .shadow }

The super-linter finds issues and reports them to the console output. Fixes are suggested in the console output but not automatically fixed, and a status check will show up as failed on the pull request.

The design of the **Super-Linter** is currently to allow linting to occur in **GitHub Actions** as a part of continuous integration occurring on pull requests as the commits get pushed. It works best when commits are being pushed early and often to a branch with an open or draft pull request. There is some desire to move this closer to local development for faster feedback on linting errors but this is not yet supported.

**The end goal of this tool:**

-   Prevent broken code from being uploaded to the default branch (_Usually_ `master` or `main`)
-   Help establish coding best practices across multiple languages
-   Build guidelines for code layout and format
-   Automate the process to help streamline code reviews

# How to use

To use this **GitHub** Action you will need to complete the following:

1.  Create a new file in your repository called `.github/workflows/linter.yml`
2.  Copy the example workflow from below into that new file, no extra configuration required
3.  Commit that file to a new branch
4.  Open up a pull request and observe the action working
5.  Enjoy your more _stable_, and _cleaner_ codebase
6.  Check out the [Wiki](https://github.com/super-linter/super-linter/wiki) for customization options

> If you pass the _Environment_ variable `GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}` in your workflow, then the **GitHub Super-Linter** will mark the status of each individual linter run in the Checks section of a pull request. Without this you will only see the overall status of the full run. There is no need to set the **GitHub** Secret as it is automatically set by GitHub, it only needs to be passed to the action.
{: .prompt-tip }

## Example connecting GitHub Action Workflow

In your repository you should have a `.github/workflows` folder with **GitHub** Action similar to below:

-   `.github/workflows/linter.yml`

This file should have the following code:

```shell
---
name: Lint Code Base

on:
  push:
    branches-ignore: [master, main]
  pull_request:
    branches: [master, main]

jobs:
  build:
    name: Lint Code Base
    runs-on: ubuntu-latest

    permissions:
      contents: read
      packages: read
      statuses: write

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Lint Code Base
        uses: super-linter/super-linter@v5
        env:
          VALIDATE_ALL_CODEBASE: false
          DEFAULT_BRANCH: main
          GITHUB_TOKEN: \$\{\{ secrets.GITHUB_TOKEN \}\}
```

## Use locally

\1. Install and run Docker on your local machine.
\2. Run the script that detects the user's shell and sets up a linting alias:

```shell
# Detect the current shell
SHELL_TYPE="$(basename "$SHELL")"

# Set the lint alias based on the detected shell
if [ "$SHELL_TYPE" = "bash" ]; then
    echo "alias lint='echo \"Linting \$(pwd)\" \
      && docker run --rm --name Linterdocker \
      -e LOG_FILE=super-linter.log \
      -e RUN_LOCAL=true \
      -e DEFAULT_WORKSPACE=/tmp/lint \
      -v \$(pwd):/tmp/lint github/super-linter'" >> ~/.bashrc
    source ~/.bashrc
elif [ "$SHELL_TYPE" = "zsh" ]; then
    echo "alias lint='echo \"Linting \$(pwd)\" \
      && docker run --rm --name Linterdocker \
      -e LOG_FILE=super-linter.log \
      -e RUN_LOCAL=true \
      -e DEFAULT_WORKSPACE=/tmp/lint \
      -v \$(pwd):/tmp/lint github/super-linter'" >> ~/.zshrc
    source ~/.zshrc
else
    echo "Unsupported shell: $SHELL_TYPE"
fi
```

\3. To perform linting on a GitHub Repository directory, you need to run the ***`lint`*** command inside that directory.
\4. To review the outcomes of Super-Linter, you can access the ***`super-linter.log`*** file.


## Environment variables

The super-linter allows you to pass the following `ENV` variables to be able to trigger different functionality.

_Note:_ All the `VALIDATE_[LANGUAGE]` variables behave in a very specific way:

-   If none of them are passed, then they all default to true.
-   If any one of the variables are set to true, we default to leaving any unset variable to false (only validate those languages).
-   If any one of the variables are set to false, we default to leaving any unset variable to true (only exclude those languages).
-   If there are `VALIDATE_[LANGUAGE]` variables set to both true and false. It will fail.

This means that if you run the linter "out of the box", all languages will be checked. But if you wish to select or exclude specific linters, we give you full control to choose which linters are run, and won't run anything unexpected.

| **ENV VAR** | **Default Value** | **Notes** |
| --- | --- | --- |
| **ACTIONS\_RUNNER\_DEBUG** | `false` | Flag to enable additional information about the linter, versions, and additional output. |
| **ANSIBLE\_CONFIG\_FILE** | `.ansible-lint.yml` | Filename for [Ansible-lint configuration](https://ansible.readthedocs.io/projects/lint/configuring/) (ex: `.ansible-lint`, `.ansible-lint.yml`) |
| **ANSIBLE\_DIRECTORY** | `/ansible` | Flag to set the root directory for Ansible file location(s), relative to `DEFAULT_WORKSPACE`. Set to `.` to use the top-level of the `DEFAULT_WORKSPACE`. |
| **BASH\_SEVERITY** | `style` | Specify the minimum severity of errors to consider in shellcheck. Valid values in order of severity are error, warning, info and style. |
| **CREATE\_LOG\_FILE** | `false` | If set to `true`, it creates the log file. You can set the log filename using the `LOG_FILE` environment variable. |
| **CSS\_FILE\_NAME** | `.stylelintrc.json` | Filename for [Stylelint configuration](https://github.com/stylelint/stylelint) (ex: `.stylelintrc.yml`, `.stylelintrc.yaml`) |
| **DEFAULT\_BRANCH** | `master` | The name of the repository default branch. |
| **DEFAULT\_WORKSPACE** | `/tmp/lint` | The location containing files to lint if you are running locally. |
| **DISABLE\_ERRORS** | `false` | Flag to have the linter complete with exit code 0 even if errors were detected. |
| **DOCKERFILE\_HADOLINT\_FILE\_NAME** | `.hadolint.yaml` | Filename for [hadolint configuration](https://github.com/hadolint/hadolint) (ex: `.hadolintlintrc.yaml`) |
| **EDITORCONFIG\_FILE\_NAME** | `.ecrc` | Filename for [editorconfig-checker configuration](https://github.com/editorconfig-checker/editorconfig-checker) |
| **ERROR\_ON\_MISSING\_EXEC\_BIT** | `false` | If set to `false`, the `bash-exec` linter will report a warning if a shell script is not executable. If set to `true`, the `bash-exec` linter will report an error instead. |
| **EXPERIMENTAL\_BATCH\_WORKER** | `false` | Flag to enable experimental parallel and batched worker. As of current only `eslint` and `cfn-lint` are supported, if there is no support, original version is used as fallback |
| **FILTER\_REGEX\_EXCLUDE** | `none` | Regular expression defining which files will be excluded from linting (ex: `.*src/test.*`) |
| **FILTER\_REGEX\_INCLUDE** | `all` | Regular expression defining which files will be processed by linters (ex: `.*src/.*`) |
| **GITHUB\_ACTIONS\_CONFIG\_FILE** | `actionlint.yml` | Filename for [Actionlint configuration](https://github.com/rhysd/actionlint/blob/main/docs/config.md) (ex: `actionlint.yml`) |
| **GITHUB\_ACTIONS\_COMMAND\_ARGS** | `null` | Additional arguments passed to `actionlint` command. Useful to [ignore some errors](https://github.com/rhysd/actionlint/blob/main/docs/usage.md#ignore-some-errors) |
| **GITHUB\_CUSTOM\_API\_URL** | `https://api.github.com` | Specify a custom GitHub API URL in case GitHub Enterprise is used: e.g. `https://github.myenterprise.com/api/v3` |
| **GITHUB\_DOMAIN** | `github.com` | Specify a custom GitHub domain in case GitHub Enterprise is used: e.g. `github.myenterprise.com` |
| **GITLEAKS\_CONFIG\_FILE** | `.gitleaks.toml` | Filename for [GitLeaks configuration](https://github.com/zricethezav/gitleaks#configuration) (ex: `.gitleaks.toml`) |
| **IGNORE\_GENERATED\_FILES** | `false` | If set to `true`, super-linter will ignore all the files with `@generated` marker but without `@not-generated` marker. |
| **IGNORE\_GITIGNORED\_FILES** | `false` | If set to `true`, super-linter will ignore all the files that are ignored by Git. |
| **JAVA\_FILE\_NAME** | `sun_checks.xml` | Filename for [Checkstyle configuration](https://checkstyle.sourceforge.io/config.html) (ex: `checkstyle.xml`) |
| **JAVASCRIPT\_DEFAULT\_STYLE** | `standard` | Flag to set the default style of JavaScript. Available options: **standard**/**prettier** |
| **JAVASCRIPT\_ES\_CONFIG\_FILE** | `.eslintrc.yml` | Filename for [ESLint configuration](https://eslint.org/docs/user-guide/configuring#configuration-file-formats) (ex: `.eslintrc.yml`, `.eslintrc.json`) |
| **JSCPD\_CONFIG\_FILE** | `.jscpd.json` | Filename for JSCPD configuration |
| **KUBERNETES\_KUBECONFORM\_OPTIONS** | `null` | Additional arguments to pass to the command-line when running **Kubernetes Kubeconform** (Example: --ignore-missing-schemas) |
| **LINTER\_RULES\_PATH** | `.github/linters` | Directory for all linter configuration rules. |
| **LOG\_FILE** | `super-linter.log` | The filename for outputting logs. All output is sent to the log file regardless of `LOG_LEVEL`. |
| **LOG\_LEVEL** | `VERBOSE` | How much output the script will generate to the console. One of `ERROR`, `WARN`, `NOTICE`, `VERBOSE`, `DEBUG` or `TRACE`. |
| **MARKDOWN\_CONFIG\_FILE** | `.markdown-lint.yml` | Filename for [Markdownlint configuration](https://github.com/DavidAnson/markdownlint#optionsconfig) (ex: `.markdown-lint.yml`, `.markdownlint.json`, `.markdownlint.yaml`) |
| **MARKDOWN\_CUSTOM\_RULE\_GLOBS** | `.markdown-lint/rules,rules/**` | Comma-separated list of [file globs](https://github.com/igorshubovych/markdownlint-cli#globbing) matching [custom Markdownlint rule files](https://github.com/DavidAnson/markdownlint/blob/main/doc/CustomRules.md). |
| **MULTI\_STATUS** | `true` | A status API is made for each language that is linted to make visual parsing easier. |
| **NATURAL\_LANGUAGE\_CONFIG\_FILE** | `.textlintrc` | Filename for [textlint configuration](https://textlint.github.io/docs/getting-started.html#configuration) (ex: `.textlintrc`) |
| **PERL\_PERLCRITIC\_OPTIONS** | `null` | Additional arguments to pass to the command-line when running **perlcritic** (Example: --theme community) |
| **PHP\_CONFIG\_FILE** | `php.ini` | Filename for [PHP Configuration](https://www.php.net/manual/en/configuration.file.php) (ex: `php.ini`) |
| **PROTOBUF\_CONFIG\_FILE** | `.protolintrc.yml` | Filename for [protolint configuration](https://github.com/yoheimuta/protolint/blob/master/_example/config/.protolint.yaml) (ex: `.protolintrc.yml`) |
| **PYTHON\_BLACK\_CONFIG\_FILE** | `.python-black` | Filename for [black configuration](https://github.com/psf/black/blob/main/docs/guides/using_black_with_other_tools.md#black-compatible-configurations) (ex: `.isort.cfg`, `pyproject.toml`) |
| **PYTHON\_FLAKE8\_CONFIG\_FILE** | `.flake8` | Filename for [flake8 configuration](https://flake8.pycqa.org/en/latest/user/configuration.html) (ex: `.flake8`, `tox.ini`) |
| **PYTHON\_ISORT\_CONFIG\_FILE** | `.isort.cfg` | Filename for [isort configuration](https://pycqa.github.io/isort/docs/configuration/config_files.html) (ex: `.isort.cfg`, `pyproject.toml`) |
| **PYTHON\_MYPY\_CONFIG\_FILE** | `.mypy.ini` | Filename for [mypy configuration](https://mypy.readthedocs.io/en/stable/config_file.html) (ex: `.mypy.ini`, `setup.config`) |
| **PYTHON\_PYLINT\_CONFIG\_FILE** | `.python-lint` | Filename for [pylint configuration](https://pylint.pycqa.org/en/latest/user_guide/run.html?highlight=rcfile#command-line-options) (ex: `.python-lint`, `.pylintrc`) |
| **RENOVATE\_SHAREABLE\_CONFIG\_PRESET\_FILE\_NAMES** | \`\` | Comma-separated filenames for [renovate shareable config preset](https://docs.renovatebot.com/config-presets/) (ex: `default.json`) |
| **RUBY\_CONFIG\_FILE** | `.ruby-lint.yml` | Filename for [rubocop configuration](https://docs.rubocop.org/rubocop/configuration.html) (ex: `.ruby-lint.yml`, `.rubocop.yml`) |
| **SCALAFMT\_CONFIG\_FILE** | `.scalafmt.conf` | Filename for [scalafmt configuration](https://scalameta.org/scalafmt/docs/configuration.html) (ex: `.scalafmt.conf`) |
| **SNAKEMAKE\_SNAKEFMT\_CONFIG\_FILE** | `.snakefmt.toml` | Filename for [Snakemake configuration](https://github.com/snakemake/snakefmt#configuration) (ex: `pyproject.toml`, `.snakefmt.toml`) |
| **SSL\_CERT\_SECRET** | `none` | SSL cert to add to the **Super-Linter** trust store. This is needed for users on `self-hosted` runners or need to inject the cert for security standards (ex. ${{ secrets.SSL\_CERT }}) |
| **SSH\_KEY** | `none` | SSH key that has access to your private repositories |
| **SSH\_SETUP\_GITHUB** | `false` | If set to `true`, adds the `github.com` SSH key to `known_hosts`. This is ignored if `SSH_KEY` is provided - i.e. the `github.com` SSH key is always added if `SSH_KEY` is provided |
| **SSH\_INSECURE\_NO\_VERIFY\_GITHUB\_KEY** | `false` | **INSECURE -** If set to `true`, does not verify the fingerprint of the github.com SSH key before adding this. This is not recommended! |
| **SQL\_CONFIG\_FILE** | `.sql-config.json` | Filename for [SQL-Lint configuration](https://sql-lint.readthedocs.io/en/latest/files/configuration.html) (ex: `sql-config.json` , `.config.json`) |
| **SQLFLUFF\_CONFIG\_FILE** | `/.sqlfluff` | Filename for [SQLFLUFF configuration](https://docs.sqlfluff.com/en/stable/configuration.html) (ex: `/.sqlfluff`, `pyproject.toml`) |
| **SUPPRESS\_FILE\_TYPE\_WARN** | `false` | If set to `true`, will hide warning messages about files without their proper extensions. Default is `false` |
| **SUPPRESS\_POSSUM** | `false` | If set to `true`, will hide the ASCII possum at top of log output. Default is `false` |
| **TERRAFORM\_TERRASCAN\_CONFIG\_FILE** | `terrascan.toml` | Filename for [terrascan configuration](https://github.com/accurics/terrascan) (ex: `terrascan.toml`) |
| **TERRAFORM\_TFLINT\_CONFIG\_FILE** | `.tflint.hcl` | Filename for [tfLint configuration](https://github.com/terraform-linters/tflint) (ex: `.tflint.hcl`) |
| **TYPESCRIPT\_DEFAULT\_STYLE** | `ts-standard` | Flag to set the default style of TypeScript. Available options: **ts-standard**/**prettier** |
| **TYPESCRIPT\_ES\_CONFIG\_FILE** | `.eslintrc.yml` | Filename for [ESLint configuration](https://eslint.org/docs/user-guide/configuring#configuration-file-formats) (ex: `.eslintrc.yml`, `.eslintrc.json`) |
| **TYPESCRIPT\_STANDARD\_TSCONFIG\_FILE** | `tsconfig.json` | Filename for [TypeScript configuration](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html) in [ts-standard](https://github.com/standard/ts-standard) (ex: `tsconfig.json`, `tsconfig.eslint.json`) |
| **USE\_FIND\_ALGORITHM** | `false` | By default, we use `git diff` to find all files in the workspace and what has been updated, this would enable the Linux `find` method instead to find all files to lint |
| **VALIDATE\_ALL\_CODEBASE** | `true` | Will parse the entire repository and find all files to validate across all types. **NOTE:** When set to `false`, only **new** or **edited** files will be parsed for validation. |
| **VALIDATE\_JSCPD\_ALL\_CODEBASE** | `false` | If set to `true`, will lint the whole codebase with JSCPD. If set to `false`, JSCPD will only lint files one by one. |
| **VALIDATE\_ANSIBLE** | `true` | Flag to enable or disable the linting process of the Ansible language. |
| **VALIDATE\_ARM** | `true` | Flag to enable or disable the linting process of the ARM language. |
| **VALIDATE\_BASH** | `true` | Flag to enable or disable the linting process of the Bash language. |
| **VALIDATE\_BASH\_EXEC** | `true` | Flag to enable or disable the linting process of the Bash language to validate if file is stored as executable. |
| **VALIDATE\_CPP** | `true` | Flag to enable or disable the linting process of the C++ language. |
| **VALIDATE\_CLANG\_FORMAT** | `true` | Flag to enable or disable the linting process of the C++/C language with clang-format. |
| **VALIDATE\_CLOJURE** | `true` | Flag to enable or disable the linting process of the Clojure language. |
| **VALIDATE\_CLOUDFORMATION** | `true` | Flag to enable or disable the linting process of the AWS Cloud Formation language. |
| **VALIDATE\_COFFEESCRIPT** | `true` | Flag to enable or disable the linting process of the Coffeescript language. |
| **VALIDATE\_CSHARP** | `true` | Flag to enable or disable the linting process of the C# language. |
| **VALIDATE\_CSS** | `true` | Flag to enable or disable the linting process of the CSS language. |
| **VALIDATE\_DART** | `true` | Flag to enable or disable the linting process of the Dart language. |
| **VALIDATE\_DOCKERFILE\_HADOLINT** | `true` | Flag to enable or disable the linting process of the Docker language. |
| **VALIDATE\_EDITORCONFIG** | `true` | Flag to enable or disable the linting process with the EditorConfig. |
| **VALIDATE\_ENV** | `true` | Flag to enable or disable the linting process of the ENV language. |
| **VALIDATE\_GHERKIN** | `true` | Flag to enable or disable the linting process of the Gherkin language. |
| **VALIDATE\_GITHUB\_ACTIONS** | `true` | Flag to enable or disable the linting process of the GitHub Actions. |
| **VALIDATE\_GITLEAKS** | `true` | Flag to enable or disable the linting process of the secrets. |
| **VALIDATE\_GO** | `true` | Flag to enable or disable the linting process of the Golang language. |
| **VALIDATE\_GOOGLE\_JAVA\_FORMAT** | `true` | Flag to enable or disable the linting process of the Java language. (Utilizing: google-java-format) |
| **VALIDATE\_GROOVY** | `true` | Flag to enable or disable the linting process of the language. |
| **VALIDATE\_HTML** | `true` | Flag to enable or disable the linting process of the HTML language. |
| **VALIDATE\_JAVA** | `true` | Flag to enable or disable the linting process of the Java language. (Utilizing: checkstyle) |
| **VALIDATE\_JAVASCRIPT\_ES** | `true` | Flag to enable or disable the linting process of the JavaScript language. (Utilizing: ESLint) |
| **VALIDATE\_JAVASCRIPT\_STANDARD** | `true` | Flag to enable or disable the linting process of the JavaScript language. (Utilizing: standard) |
| **VALIDATE\_JSCPD** | `true` | Flag to enable or disable the JSCPD. |
| **VALIDATE\_JSON** | `true` | Flag to enable or disable the linting process of the JSON language. |
| **VALIDATE\_JSX** | `true` | Flag to enable or disable the linting process for jsx files (Utilizing: ESLint) |
| **VALIDATE\_KOTLIN** | `true` | Flag to enable or disable the linting process of the Kotlin language. |
| **VALIDATE\_KOTLIN\_ANDROID** | `true` | Flag to enable or disable the linting process of the Kotlin language. (Utilizing: `ktlint --android`) |
| **VALIDATE\_KUBERNETES\_KUBECONFORM** | `true` | Flag to enable or disable the linting process of Kubernetes descriptors with Kubeconform |
| **VALIDATE\_LATEX** | `true` | Flag to enable or disable the linting process of the LaTeX language. |
| **VALIDATE\_LUA** | `true` | Flag to enable or disable the linting process of the language. |
| **VALIDATE\_MARKDOWN** | `true` | Flag to enable or disable the linting process of the Markdown language. |
| **VALIDATE\_NATURAL\_LANGUAGE** | `true` | Flag to enable or disable the linting process of the natural language. |
| **VALIDATE\_OPENAPI** | `true` | Flag to enable or disable the linting process of the OpenAPI language. |
| **VALIDATE\_PERL** | `true` | Flag to enable or disable the linting process of the Perl language. |
| **VALIDATE\_PHP** | `true` | Flag to enable or disable the linting process of the PHP language. (Utilizing: PHP built-in linter) (keep for backward compatibility) |
| **VALIDATE\_PHP\_BUILTIN** | `true` | Flag to enable or disable the linting process of the PHP language. (Utilizing: PHP built-in linter) |
| **VALIDATE\_PHP\_PHPCS** | `true` | Flag to enable or disable the linting process of the PHP language. (Utilizing: PHP CodeSniffer) |
| **VALIDATE\_PHP\_PHPSTAN** | `true` | Flag to enable or disable the linting process of the PHP language. (Utilizing: PHPStan) |
| **VALIDATE\_PHP\_PSALM** | `true` | Flag to enable or disable the linting process of the PHP language. (Utilizing: PSalm) |
| **VALIDATE\_POWERSHELL** | `true` | Flag to enable or disable the linting process of the Powershell language. |
| **VALIDATE\_PROTOBUF** | `true` | Flag to enable or disable the linting process of the Protobuf language. |
| **VALIDATE\_PYTHON** | `true` | Flag to enable or disable the linting process of the Python language. (Utilizing: pylint) (keep for backward compatibility) |
| **VALIDATE\_PYTHON\_BLACK** | `true` | Flag to enable or disable the linting process of the Python language. (Utilizing: black) |
| **VALIDATE\_PYTHON\_FLAKE8** | `true` | Flag to enable or disable the linting process of the Python language. (Utilizing: flake8) |
| **VALIDATE\_PYTHON\_ISORT** | `true` | Flag to enable or disable the linting process of the Python language. (Utilizing: isort) |
| **VALIDATE\_PYTHON\_MYPY** | `true` | Flag to enable or disable the linting process of the Python language. (Utilizing: mypy) |
| **VALIDATE\_PYTHON\_PYLINT** | `true` | Flag to enable or disable the linting process of the Python language. (Utilizing: pylint) |
| **VALIDATE\_R** | `true` | Flag to enable or disable the linting process of the R language. |
| **VALIDATE\_RAKU** | `true` | Flag to enable or disable the linting process of the Raku language. |
| **VALIDATE\_RENOVATE** | `true` | Flag to enable or disable the linting process of the Renovate configuration files. |
| **VALIDATE\_RUBY** | `true` | Flag to enable or disable the linting process of the Ruby language. |
| **VALIDATE\_RUST\_2015** | `true` | Flag to enable or disable the linting process of the Rust language. (edition: 2015) |
| **VALIDATE\_RUST\_2018** | `true` | Flag to enable or disable the linting process of Rust language. (edition: 2018) |
| **VALIDATE\_RUST\_2021** | `true` | Flag to enable or disable the linting process of Rust language. (edition: 2021) |
| **VALIDATE\_RUST\_CLIPPY** | `true` | Flag to enable or disable the clippy linting process of Rust language. |
| **VALIDATE\_SCALAFMT** | `true` | Flag to enable or disable the linting process of Scala language. (Utilizing: scalafmt --test) |
| **VALIDATE\_SHELL\_SHFMT** | `true` | Flag to enable or disable the linting process of Shell scripts. (Utilizing: shfmt) |
| **VALIDATE\_SNAKEMAKE\_LINT** | `true` | Flag to enable or disable the linting process of Snakefiles. (Utilizing: snakemake --lint) |
| **VALIDATE\_SNAKEMAKE\_SNAKEFMT** | `true` | Flag to enable or disable the linting process of Snakefiles. (Utilizing: snakefmt) |
| **VALIDATE\_STATES** | `true` | Flag to enable or disable the linting process for AWS States Language. |
| **VALIDATE\_SQL** | `true` | Flag to enable or disable the linting process of the SQL language. |
| **VALIDATE\_SQLFLUFF** | `true` | Flag to enable or disable the linting process of the SQL language. (Utilizing: sqlfuff) |
| **VALIDATE\_TEKTON** | `true` | Flag to enable or disable the linting process of the Tekton language. |
| **VALIDATE\_TERRAFORM\_FMT** | `true` | Flag to enable or disable the formatting process of the Terraform files. |
| **VALIDATE\_TERRAFORM\_TERRASCAN** | `true` | Flag to enable or disable the linting process of the Terraform language for security related issues. |
| **VALIDATE\_TERRAFORM\_TFLINT** | `true` | Flag to enable or disable the linting process of the Terraform language. (Utilizing tflint) |
| **VALIDATE\_TERRAGRUNT** | `true` | Flag to enable or disable the linting process for Terragrunt files. |
| **VALIDATE\_TSX** | `true` | Flag to enable or disable the linting process for tsx files (Utilizing: ESLint) |
| **VALIDATE\_TYPESCRIPT\_ES** | `true` | Flag to enable or disable the linting process of the TypeScript language. (Utilizing: ESLint) |
| **VALIDATE\_TYPESCRIPT\_STANDARD** | `true` | Flag to enable or disable the linting process of the TypeScript language. (Utilizing: ts-standard) |
| **VALIDATE\_XML** | `true` | Flag to enable or disable the linting process of the XML language. |
| **VALIDATE\_YAML** | `true` | Flag to enable or disable the linting process of the YAML language. |
| **YAML\_CONFIG\_FILE** | `.yaml-lint.yml` | Filename for [Yamllint configuration](https://yamllint.readthedocs.io/en/stable/configuration.html) (ex: `.yaml-lint.yml`, `.yamllint.yml`) |
| **YAML\_ERROR\_ON\_WARNING** | `false` | Flag to enable or disable the error on warning for Yamllint. |

## Limitations

Below are a list of the known limitations for the **GitHub Super-Linter**:

-   Due to being completely packaged at runtime, you will not be able to update dependencies or change versions of the enclosed linters and binaries
-   Additional details from `package.json` are not read by the **GitHub Super-Linter**
-   Downloading additional codebases as dependencies from private repositories will fail due to lack of permissions

# Documentation

- [Super-Linter](https://github.com/marketplace/actions/super-linter)