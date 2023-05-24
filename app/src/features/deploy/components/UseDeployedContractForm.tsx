import { Form, Input } from "@fuel-ui/react";

export function UseDeployedContractForm() {
    return (
        <Form.Control className="deployedContractId">
            <Input>
                <Input.Field
                    inputMode="text"
                    id="deployedContractId"
                    name="Deployed Contract ID"
                    placeholder="0x..."
                />
            </Input>
        </Form.Control>
    );
}