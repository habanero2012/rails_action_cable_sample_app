import {FINISH_FETCH_FEEDS, START_FETCH_FEEDS, TimeLineAction} from "../actions/tileline";

type User = {
    id: number,
    name: string,
    user_path: string,
    gravatar_url: string,
};

export type Micropost = {
    id: number,
    content: string,
    user: User,
    path: string,
    picture_path: string,
    created_at: string,
}

export type State = {
    loginId: number,
    microposts: Micropost[],
    startFetchFeeds: boolean,
}

export const initialState: State = {
    loginId: -1,
    microposts: [],
    startFetchFeeds: false,
};

const reducer = (state: State, action: TimeLineAction): State => {
    switch (action.type) {
        case START_FETCH_FEEDS:
            return {...state, startFetchFeeds: true};
        case FINISH_FETCH_FEEDS:
            const microposts = state.microposts.concat(action.payload.microposts);
            return {...state, microposts, startFetchFeeds: false};
    }
    return state;
}

export default reducer;