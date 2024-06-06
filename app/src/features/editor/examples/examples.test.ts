import { EXAMPLE_CONTRACTS } from ".";
import { LOCAL_SERVER_URI } from "../../../constants";
import { ExampleMenuItem } from "../components/ExampleDropdown";

describe(`test examples`, () => {
  describe(`transpile solidity examples`, () => {
    const uri = `${LOCAL_SERVER_URI}/transpile`;

    it.each(
      EXAMPLE_CONTRACTS["solidity"].map(({ label, code }: ExampleMenuItem) => [
        label,
        code,
      ]),
    )("%s", async (_label, code) => {
      // Call server
      const request = new Request(uri, {
        method: "POST",
        body: JSON.stringify({
          contract: code,
          language: "solidity",
        }),
      });

      const response = await fetch(request);
      const { error, swayContract } = await response.json();

      expect(error).toBeUndefined();
      expect(swayContract).toContain("contract;");
    });
  });

  describe(`compile sway examples`, () => {
    const uri = `${LOCAL_SERVER_URI}/compile`;

    it.each(
      EXAMPLE_CONTRACTS["sway"].map(({ label, code }: ExampleMenuItem) => [
        label,
        code,
      ]),
    )(
      "%s",
      async (_label, code) => {
        // Call server
        const request = new Request(uri, {
          method: "POST",
          body: JSON.stringify({
            contract: code,
            toolchain: "testnet",
          }),
        });

        const response = await fetch(request);
        const { error, abi, bytecode, storageSlots, forcVersion } =
          await response.json();

        expect(error).toBeUndefined();
        expect(abi).toBeDefined();
        expect(bytecode).toBeDefined();
        expect(storageSlots).toBeDefined();
        expect(forcVersion).toBeDefined();
      },
      40000,
    );
  });
});
