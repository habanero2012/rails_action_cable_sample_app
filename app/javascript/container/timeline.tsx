import React, {FC, useEffect} from 'react';
import Micropost from "../component/micropost";
import {useDispatchContext, useStateContext} from "../utils/provider";
import {State} from "../reducers/timeline";
import MoreBtn from "../component/more_btn";
import consumer from "../channels/consumer";
import {receiveLatestMicropostAction} from "../actions/tileline";

const Timeline = () => {
    const state = useStateContext() as State;
    const microposts = state.microposts.map((micropost) => <Micropost key={micropost.id} micropost={micropost}
                                                                      loginId={state.loginId}/>);
    const dispatch = useDispatchContext();

    useEffect(() => {
        consumer.subscriptions.create("TimelineChannel", {
            received(data) {
                dispatch(receiveLatestMicropostAction(JSON.parse(data)));
            }
        });
    }, []);

    return (
        <>
            <div className="card">
                <div className="card-body microposts">
                    {microposts}
                </div>
            </div>
            <MoreBtn/>
        </>
    );
};

export default Timeline;