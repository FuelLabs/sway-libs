export enum DeployState {
  NOT_DEPLOYED = 'NOT_DEPLOYED',
  DEPLOYING = 'DEPLOYING',
  DEPLOYED = 'DEPLOYED',
}

export enum NetworkState {
  CAN_CONNECT = 'CAN_CONNECT',
  CONNECTING = 'CONNECTING',
  CAN_DISCONNECT = 'CAN_DISCONNECT',
  DISCONNECTING = 'DISCONNECTING',
}

export type CallType = 'call' | 'dryrun';
