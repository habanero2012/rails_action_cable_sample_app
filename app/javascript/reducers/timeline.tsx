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

type Action = {
    type: string,
    payload: any,
}

export type State = {
    loginId: number,
    microposts: Micropost[]
}

export const initialState: State = {
    loginId: -1,
    microposts: [],
};

const reducer = (state: State, action: Action): State => {
    console.log(state);
    return state;
}

export default reducer;