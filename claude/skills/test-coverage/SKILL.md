---
name: test-coverage
model: haiku
description: Use when generate test coverage, or when asked "generate test coverage", "generate coverage", "find coverage". Provide how to get test coverage of specific component.
---

<purpose>
create test coverage and report coverage of the specific component
</purpose>

<steps name="kover">
<step>Run kover task</step>
<step>Read coverage report xml</step>
<step>Find coverage of the target component</step>
</steps>

<features>
<feature name="kover">
./gradlew :app:koverXmlReportDemoDebug
</feature>
<feature name="find coverage report">
There is coverage report at app/build/reports/kover/reportDemoDebug.xml
</feature>
</features>

