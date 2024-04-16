type AllowedProperty = string | number | boolean | null;

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null;
}

function isAllowedEntry(
  entry: [string, unknown]
): entry is [string, AllowedProperty] {
  const [_key, value] = entry;
  return (
    typeof value === 'string' ||
    typeof value === 'number' ||
    typeof value === 'boolean' ||
    value === null
  );
}

export function toMetricProperties(
  error: Error,
  metadata?: Record<string, unknown>
): Record<string, AllowedProperty> | undefined {
  const combined = { ...metadata };
  if (isRecord(error.cause)) {
    Object.assign(combined, error.cause);
  }
  if (!!Object.keys(combined).length) {
    return Object.entries(combined)
      .filter(isAllowedEntry)
      .reduce((acc: Record<string, AllowedProperty>, [key, value]) => {
        acc[key] = value;
        return acc;
      }, {});
  }
  return undefined;
}
