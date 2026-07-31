# CLAUDE.md

## Purpose
Project guidance for Claude when working in this repository. Mirrors `AGENTS.md` — keep the two in sync.

## Coding style preferences

- Prefer small, focused classes and methods.
- Extract logic into dedicated classes early when a method starts doing multiple things.
- Keep one responsibility per class.
- Prefer explicit orchestration classes that delegate work to helpers/services.
- Prefer readable, linear flow over compact "smart" code.
- When possible, use `blank?` for Rails presence checks.

## API/style conventions

- When using instance-style services, keep input as initializer args and expose clear public methods.
- Use `delegate` for collaboration boundaries when it improves readability — prefer `delegate :attr, to: :object` over inline chained calls (`object.attr`) at each call site when a class reads an attribute off an associated object.

  ```ruby
  # Prefer
  delegate :chat_id, :resolved_media_url, to: :parent_request, private: true

  def call
    Telegram.bot.send_message(chat_id:, text: resolved_media_url)
  end

  # Over
  def call
    Telegram.bot.send_message(chat_id: parent_request.chat_id, text: parent_request.resolved_media_url)
  end
  ```

- Prefer memoization (`Memery` + `memoize def`) for repeat derived values inside an object.
- Use `memoize` consistently for computed/helper methods that are reused within the same object lifecycle.

## Refactoring preferences

- If code repeats, extract a method/class rather than duplicating.
- If a method performs IO and orchestration together, split IO into its own class.
- Keep job classes as orchestrators; move source-specific logic to dedicated collaborators.
- Keep naming domain-oriented and consistent with existing patterns.

## Error handling

- Fail fast with clear errors for missing critical inputs.
- Avoid silent failures unless explicitly requested by product behavior.

## Practical guidance for this repo

- For "store image" flow, keep responsibilities separated:
  - job orchestrates
  - resolver decides source
  - downloaders fetch bytes
  - uploader handles internal bucket URL generation/upload
- Prefer polymorphic associations for shared child entities (e.g., `StoredImage`).

## Testing preferences

- Prefer creating real persisted records (via factories/fixtures) in specs instead of using doubles for model records.
- Use doubles for external dependencies/IO boundaries (APIs, SDK clients, network calls), not for ActiveRecord entities when a real record can be used.
- Use plain `describe` (not `RSpec.describe`).
- Prefer this RSpec structure:
  - `let(:input) { ... }`
  - `subject { described_class.new(input).public_method }`
  - one-line expectations: `it { is_expected.to ... }`
  - context blocks for variations (`context "when ..."` with overridden `let`).
- Keep specs concise and style-consistent across files.
