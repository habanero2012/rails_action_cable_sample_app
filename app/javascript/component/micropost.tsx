import React, {FC} from 'react';
import {Micropost} from "../reducers/timeline";

type Props = {
    micropost: Micropost,
    loginId: number,
}

const Micropost: FC<Props> = ({micropost, loginId}) => {
    const deleteBtn = micropost.user.id == loginId ?
        <a data-confirm="You sure?" rel="nofollow" data-method="delete" href={micropost.path}>delete</a> : '';

    const img = micropost.picture_path ? (
        <>
            <img src={micropost.picture_path}/>
            <br/>
        </>
    ) : '';

    return (
        <div className="post" id={"micropost-" + micropost.id}>
            <div className="user-block">
                <img alt="Example User!!" className="img-circle img-bordered-sm"
                     src={micropost.user.gravatar_url}/>
                <span className="username">
                    <a href={micropost.user.user_path}>{micropost.user.name}</a>
                </span>
                <span className="description">{micropost.created_at}</span>
            </div>
            <p>{micropost.content}</p>
            {img}
            {deleteBtn}
        </div>
    );
};

export default Micropost;