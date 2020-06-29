import React, {FC} from 'react';
import Micropost from "../component/micropost";
import {useStateContext} from "../utils/provider";
import {State} from "../reducers/timeline";

const Timeline = () => {
    const state = useStateContext() as State;
    const microposts = state.microposts.map((micropost) => <Micropost key={micropost.id} micropost={micropost} loginId={state.loginId} />);
    return (
        <div className="card">
            <div className="card-body microposts">
                {microposts}
            </div>
        </div>
    );
};

export default Timeline;