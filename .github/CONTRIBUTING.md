# Contributing to Stelligent Nu

:100::boom:

The following is a set of guidelines for contributing to Stelligent Nu

## Table Of Contents

<!-- TOC -->

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Your First Code Contribution](#your-first-code-contribution)
  - [Pull Requests](#pull-requests)
- [Style Guides](#style-guides)
  - [Git Commit Messages](#git-commit-messages)
- [Additional Notes](#additional-notes)
  - [Issue and Pull Request Labels](#issue-and-pull-request-labels)

<!-- /TOC -->

## Code of Conduct

This project and everyone participating in it is governed by the
[Code of Conduct](.github/CODE_OF_CONDUCT.md). By participating, you are
expected to uphold this code.

## How To Contribute

### Reporting Bugs

This section guides you through submitting a bug report for Stelligent Nu.
Following these guidelines helps maintainers and the community understand your
report :pencil:, reproduce the behavior :computer: :computer:, and find related
reports :mag_right:.

Before creating bug reports, please check
[this list](#before-submitting-a-bug-report) as you might find out that you
don't need to create one. When you are creating a bug report, please
[include as many details as possible](#how-do-i-submit-a-good-bug-report).
Fill out [the required template](.github/ISSUE_TEMPLATE.md), the information
it asks for helps us resolve issues faster.

> __Note:__ If you find a __Closed__ issue that seems like it is the same thing
> that you're experiencing, open a new issue and include a link to the original
> issue in the body of your new one.

#### Before Submitting A Bug Report

- __Perform a [cursory search](https://github.com/stelligent/stelligent-nu/issues?utf8=%E2%9C%93&q=is%3Aissueu)__
  to see if the problem has already been reported. If it has,
  __and the issue is still open__, add a comment to the existing issue instead
  of opening a new one.

#### Submitting A (Good) Bug Report

Bugs are tracked as [GitHub issues](https://guides.github.com/features/issues/).
Create an issue and provide the following information by filling in
[the template](.github/ISSUE_TEMPLATE.md).

Explain the problem and include additional details to help maintainers
reproduce the problem:

- __Use a clear and descriptive title__ for the issue to identify the problem.
- __Describe the exact steps which reproduce the problem__ in as many details
  as possible. For example, start by explaining how you started Stelligent Nu,
  e.g. which topic and lab you are on, or how you started Stelligent Nu
  otherwise. When listing steps,
  __don't just say what you did, but explain howyou did it__. For example, if
  you moved the cursor to the end of a line, explain if you used the mouse, or
  a keyboard shortcut or an Stelligent Nu question, and if so which one?
- __Provide specific examples to demonstrate the steps__. Include links to
  files or GitHub projects, or copy/pasteable snippets, which you use in those
  examples. If you're providing snippets in the issue, use
  [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
- __Describe the behavior you observed after following the steps__ and point
  out what exactly is the problem with that behavior.
- __Explain which behavior you expected to see instead and why.__

Provide more context by answering these questions:

- __Did the problem start happening recently__ (e.g. after completing a lab on
  Stelligent Nu) or was this always a problem?
- __Can you reliably reproduce the issue?__ If not, provide details about how
  often the problem happens and under which conditions it normally happens.

Include details about your configuration and environment:

- __What's the name and version of the OS you're using__?

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for
Stelligent Nu, including completely new features and minor improvements to
existing functionality. Following these guidelines helps maintainers and the
community understand your suggestion :pencil: and find related suggestions
:mag_right:.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion)
as you might find out that you don't need to create one. When you are creating
an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-a-good-enhancement-suggestion).
Fill in [the template](.github/ISSUE_TEMPLATE.md), including the steps that you
imagine you would take if the feature you're requesting existed.

#### Before Submitting An Enhancement Suggestion

- __Perform a [cursory search](https://github.com/stelligent/stelligent-nu/issues?utf8=%E2%9C%93&q=is%3Aissue)__
  to see if the enhancement has already been suggested. If it has, add a
  comment to the existing issue instead of opening a new one.

#### Submitting A (Good) Enhancement Suggestion

Enhancement suggestions are tracked as [GitHub issues](https://guides.github.com/features/issues/).
Create an issue and provide the following information:

- __Use a clear and descriptive title__ for the issue to identify the
  suggestion.
- __Provide a step-by-step description of the suggested enhancement__ in as
  many details as possible.
- __Provide specific examples to demonstrate the steps__. Include
  copy/pasteable snippets which you use in those examples, as
  [Markdown code blocks](https://help.github.com/articles/markdown-basics/#multiple-lines).
- __Describe the current behavior__ and
  __explain which behavior you expected to see instead__ and why.
- __Explain why this enhancement would be useful__ to most Stelligent Nu users.
- __Specify the name and version of the OS you're using.__

### Your First Code Contribution

Unsure where to begin contributing to Stelligent Nu? You can start by looking
through these `help-wanted` issues:

- [Help wanted issues][help-wanted] - issues which should only require a few
  lines of code, and a test or two.

Both issue lists are sorted by total number of comments. While not perfect,
number of comments is a reasonable proxy for impact a given change will have.

### Pull Requests

The process described here has several goals:

- Maintain Stelligent Nu's quality
- Fix problems that are important to users
- Engage the community in working toward the best possible Stelligent Nu
  Coursework
- Enable a sustainable system for Stelligent Nu's maintainers to review
  contributions

Please follow these steps to have your contribution considered by the
maintainers:

1. Follow all instructions in [the template](.github/PULL_REQUEST_TEMPLATE.md)
1. Follow the [styleguides](#styleguides)
1. Ensure you have linted your pull request with the [markdownlint gem](https://github.com/markdownlint/markdownlint).
1. After you submit your pull request, verify that all [status checks](https://help.github.com/articles/about-status-checks/)
   are passing.

> _What if the status checks are failing?_
>
> If a status check is failing, and you believe that the failure is unrelated to
> your change, please leave a comment on the pull request explaining why you
> believe the failure is unrelated. A maintainer will re-run the status check for
> you. If we conclude that the failure was a false positive, then we will open an
> issue to track that problem with our status check suite.

While the prerequisites above must be satisfied prior to having your pull
request reviewed, the reviewer(s) may ask you to complete additional design
work, tests, or other changes before your pull request can be ultimately
accepted.

## Style Guides

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line
- Consider starting the commit message with an applicable emoji:
  - :art: `:art:` when improving the format/structure of the code
  - :racehorse: `:racehorse:` when improving performance
  - :non-potable_water: `:non-potable_water:` when plugging memory leaks
  - :memo: `:memo:` when writing docs
  - :penguin: `:penguin:` when fixing something on Linux
  - :apple: `:apple:` when fixing something on macOS
  - :checkered_flag: `:checkered_flag:` when fixing something on Windows
  - :bug: `:bug:` when fixing a bug
  - :fire: `:fire:` when removing code or files
  - :green_heart: `:green_heart:` when fixing the CI build
  - :white_check_mark: `:white_check_mark:` when adding tests
  - :lock: `:lock:` when dealing with security
  - :arrow_up: `:arrow_up:` when upgrading dependencies
  - :arrow_down: `:arrow_down:` when downgrading dependencies
  - :shirt: `:shirt:` when removing linter warnings

## Additional Notes

### Issue and Pull Request Labels

This section lists the labels we use to help us track and manage issues and
pull requests.

The labels are loosely grouped by their purpose, but it's not required that
every issue have a label from every group or that an issue can't have more than
one label from the same group.

Please open an issue on `stelligent/stelligent-nu` if you have suggestions for
new labels, and if you notice some labels are missing on some repositories,
then please open an issue on that repository.
