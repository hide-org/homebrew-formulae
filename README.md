# Homebrew formulae for Hide

## How do I install these formulae?

`brew install artmoskvin/hide/<formula>`

Or `brew tap artmoskvin/hide` and then `brew install <formula>`.

Or, in a [`brew bundle`](https://github.com/Homebrew/homebrew-bundle) `Brewfile`:

```ruby
tap "artmoskvin/hide"
brew "<formula>"
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## Development

To test the formula, run `brew test --verbose artmoskvin/hide/hide`. If `brew` complains about missing dependencies run `brew install --formula --only-dependencies --include-test artmoskvin/hide/hide`.

To audit the formula, run `brew audit --strict --online --new --formula artmoskvin/hide/hide`.

To inspect the style of the formula, run `brew style artmoskvin/hide`.
