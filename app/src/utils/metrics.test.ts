import { toMetricProperties } from "./metrics";

describe(`test toMetricProperties`, () => {
  test.each`
    label                          | cause                 | metadata              | expected
    ${"with metadata and cause"}   | ${{ source: "test" }} | ${{ other: "other" }} | ${{ source: "test", other: "other" }}
    ${"with invalid cause"}        | ${"str"}              | ${undefined}          | ${undefined}
    ${"without cause or metadata"} | ${undefined}          | ${undefined}          | ${undefined}
    ${"with cause only"}           | ${{ source: "test" }} | ${undefined}          | ${{ source: "test" }}
    ${"with metadata only"}        | ${undefined}          | ${{ other: "other" }} | ${{ other: "other" }}
  `("$label", ({ cause, metadata, expected }) => {
    const error = cause ? new Error("Test", { cause }) : new Error("Test");
    expect(toMetricProperties(error, metadata)).toEqual(expected);
  });
});
