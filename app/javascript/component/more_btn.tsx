import React, {FC} from 'react';
import axios from 'axios';
import {useDispatchContext, useStateContext} from "../utils/provider";
import {finishFetchFeedsAction, startFetchFeedsAction} from "../actions/tileline";
import {Micropost, State} from "../reducers/timeline";

const MoreBtn = () => {
    const state = useStateContext() as State;
    const dispatch = useDispatchContext();

    const onClick = () => {
        if (state.startFetchFeeds) return; // 通信中の場合は何もしない

        dispatch(startFetchFeedsAction());

        const query = state.microposts.length ? '?micropost_id=' + state.microposts[state.microposts.length - 1].id : '';

        axios.get('/api/feeds' + query)
            .then((response) => {
                const microposts = response.data as Micropost[];
                dispatch(finishFetchFeedsAction(microposts));
            });
    };

    return <div className="btn btn-block btn-info" onClick={onClick}>もっと見る</div>;
};

export default MoreBtn;