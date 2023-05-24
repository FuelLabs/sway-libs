export enum DeployState {
  NOT_DEPLOYED,
  DEPLOYING,
  DEPLOYED,
}

export enum NetworkState {
  CAN_CONNECT,
  CONNECTING,
  CAN_DISCONNECT,
  DISCONNECTING,
}

export type CallType = 'call' | 'dryrun';
