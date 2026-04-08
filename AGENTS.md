# AGENTS.md

## Purpose
Project guidance for AI/code agents working in this repository.

## Coding style preferences

- Prefer small, focused classes and methods.
- Extract logic into dedicated classes early when a method starts doing multiple things.
- Keep one responsibility per class.
- Prefer explicit orchestration classes that delegate work to helpers/services.
- Prefer readable, linear flow over compact "smart" code.
- When possible, use `blank?` for Rails presence checks.

## API/style conventions

- Prefer class-level `.call` convenience methods for service-like classes.
- When using instance-style services, keep input as initializer args and expose clear public methods.
- Use `delegate` for collaboration boundaries when it improves readability.
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

