import {Micropost} from "../reducers/timeline";

export const START_FETCH_FEEDS = 'START_FETCH_FEEDS' as const;
export const FINISH_FETCH_FEEDS = 'FINISH_FETCH_FEEDS' as const;
export const RECEIVE_LATEST_MICROPOST = 'RECEIVE_LATEST_MICROPOST' as const;

export const startFetchFeedsAction = () => {
    return {type: START_FETCH_FEEDS, payload: null}
}

export const finishFetchFeedsAction = (microposts: Micropost[]) => {
    return {type: FINISH_FETCH_FEEDS, payload: {microposts}}
}

export const receiveLatestMicropostAction = (micropost: Micropost) => {
    return {type: RECEIVE_LATEST_MICROPOST, payload: {micropost}}
}

export type TimeLineAction = ReturnType<typeof startFetchFeedsAction |
    typeof finishFetchFeedsAction |
    typeof receiveLatestMicropostAction>;
