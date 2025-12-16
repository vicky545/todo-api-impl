# Copilot instructions — todo-api-impl

Short, actionable guidance for AI coding agents working in this repository.

## Quick facts 🧭
- Mule application packaged as a `mule-application` (see `pom.xml`).
- HTTP listener binds to 0.0.0.0:8081 (see `src/main/mule/global.xml`).
- API router is generated from an OAS file via APIkit (dependency `todo-task-api` in `pom.xml`).
- Local dev DB: `docker-compose.yml` runs MySQL (user/password: `user`/`password`, DB `mysqldb`). Use `docker compose up -d`.
- Build & tests: use Maven; MUnit tests run via `mvn test` (MUnit plugin configured in `pom.xml`).

## Big picture / architecture 🏗️
- Single Mule application that exposes a REST API (APIkit router). The main entry flow is `todo-task-api-main` in `src/main/mule/todo-api-impl.xml`.
- Each API operation is implemented as a sub-flow (e.g. `get-task-by-id-subflow` in `src/main/mule/get-task-by-id.xml`). The top-level flows use names like `get:\tasks` or `post:\tasks` — that's APIkit's naming convention.
- Persistence uses Mule DB connector with a MySQL backend. The DB config is `Mysql_Database_Config` in `src/main/mule/global.xml`.

## Developer workflows & commands 🔧
- Start local MySQL for integration/dev: from repository root run:
  - `docker compose up -d` (recommended modern CLI) — exposes MySQL on `localhost:3306`.
- Run unit tests / MUnit tests:
  - `mvn test` (MUnit plugin executes during the `test` phase and produces coverage reports).
- Build the Mule artifact:
  - `mvn clean package` (uses `mule-maven-plugin` to produce the `mule-application` artifact).

## Patterns and conventions to follow ✍️
- API endpoints are declared by APIkit; do not manually rename top-level flows unless you intend to change the OAS.
- Use sub-flows for operation implementations. Example files:
  - `src/main/mule/create-new-task.xml`
  - `src/main/mule/get-task-by-id.xml`
  - `src/main/mule/get-all-tasks.xml`
  - `src/main/mule/update-task-by-id-subflow.xml`
  - `src/main/mule/delete-task-by-id-subflow.xml`
- SQL is embedded in `db:sql` elements and uses named parameters (e.g. `SELECT * FROM tasks WHERE id = :myId`). Input parameters are passed with `db:input-parameters` using `attributes.uriParams` when fetching path params.
- Error handling: flows raise typed errors like `APP:TASK_NOT_FOUND`. Error handlers map to HTTP statuses by setting `vars.httpStatus` and returning a JSON payload — follow this pattern when adding new errors.
- DataWeave transforms are stored under `src/main/resources/dw/*.dwl`. Reuse these DW scripts for consistent responses and error payloads.

## Testing specifics (MUnit) ✅
- Tests live under `src/test/munit`. Tests mock DB connector calls by referring to the processor `doc:id` attribute. Example:
  - The `db:select` in `get-task-by-id.xml` has `doc:id="oqtbkr"` and the test mocks it with `<munit-tools:mock-when processor="db:select">` and matching `doc:id` in `with-attribute`.
- Use `<munit:set-event>` to simulate request attributes (e.g., `uriParams`) and to call sub-flows directly for focused unit tests.

## Integration points & dependencies 🔗
- API definition: referenced in `src/main/mule/global.xml` via `apikit:config` pointing at `resource::...:todo-task-api.yaml`. The OAS comes from the `todo-task-api` dependency in `pom.xml`.
- MySQL connector: `mysql-connector-java` is declared as a dependency and also as a shared library in `mule-maven-plugin`.

## What to look for when changing code 🔎
- When adding new DB queries, assign a unique `doc:id` so MUnit tests can mock the processor.
- When adding endpoints, prefer updating the API spec (the `todo-task-api` OAS) rather than only adding flows; APIkit flows and validation are driven by that OAS.
- Keep response DataWeave scripts in `src/main/resources/dw` to make them easy to test/mocks reuse.

## Examples (copy/paste) 🧾
- Mocking DB select in MUnit:
```xml
<munit-tools:mock-when processor="db:select">
  <munit-tools:with-attributes>
    <munit-tools:with-attribute whereValue="oqtbkr" attributeName="doc:id"/>
  </munit-tools:with-attributes>
  <munit-tools:then-return>
    <munit-tools:payload value="#[[{'id': 16, 'title': 'mytitle', 'completed': 0}]]" mediaType="application/java"/>
  </munit-tools:then-return>
</munit-tools:mock-when>
```

## Files & places of interest 📁
- `pom.xml` — build, Mule plugin, MUnit plugin, dependencies
- `docker-compose.yml` — local MySQL service
- `src/main/mule/global.xml` — listener & DB config & APIkit config
- `src/main/mule/*.xml` — flows and sub-flows
- `src/main/resources/dw/` — DataWeave scripts
- `src/test/munit/` — unit tests and MUnit patterns

---

If anything above is missing or you'd like more examples (e.g., how to write a new MUnit for an insert/update), tell me which area to expand and I will iterate. :white_check_mark: