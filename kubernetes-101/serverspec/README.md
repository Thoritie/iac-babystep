# ServerSpec Integration Test

Validate dev server configuration

Serverspec allows for infrastructure code to be written using Test Driven Development (TDD), by expressing the state that the infrastructure must provide and then writing infrastructure code that implements those expectation. The biggest benefit is that with a suite of Serverspec expectations in place, developers can refactor infrastructure code with a high degree of confidence that a change does not produce any undesirable side-effects.

## Getting Started

To run serverspec test, it's require ruby environment

### Prerequisites

Use rbenv to separate environment, rbenv is lightweight Ruby version management tool.

Install rbenv on macOSX
```
brew install rbenv
```
Set up rbenv in shell

```
rbenv init
```
or run `eval "$(rbenv init -)"` if needed

Set specific version

```
rbenv local 2.3.6
```

### Installing Dependencies

Execute `bundle` to install all dependencies, install bundle if needed

```
bundle
```

## Running the tests
To run test, can see all availabel tasks by
```
rake -T
```

### Example

```
rake spec:app-dev.prontomarketing.com
```