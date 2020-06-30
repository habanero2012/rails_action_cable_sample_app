import React, {FC} from 'react';
import Micropost from "../component/micropost";
import {useStateContext} from "../utils/provider";
import {State} from "../reducers/timeline";
import MoreBtn from "../component/more_btn";

const Timeline = () => {
    const state = useStateContext() as State;
    const microposts = state.microposts.map((micropost) => <Micropost key={micropost.id} micropost={micropost}
                                                                      loginId={state.loginId}/>);
    return (
        <>
            <div className="card">
                <div className="card-body microposts">
                    {microposts}
                </div>
            </div>
            <MoreBtn />
        </>
    );
};

export default Timeline;