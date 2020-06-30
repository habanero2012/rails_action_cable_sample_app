import React from 'react'
import ReactDOM from 'react-dom'

import Timeline from "../container/timeline";
import Provider from "../utils/provider";

import reducer, {initialState} from "../reducers/timeline";

document.addEventListener('DOMContentLoaded', () => {
    const app = document.getElementById('app');
    const microposts = JSON.parse(app.getAttribute('data-microposts'));
    const loginId = JSON.parse(app.getAttribute('data-login-id'));
    const state = {...initialState, microposts, loginId};

    ReactDOM.render(
        <Provider reducer={reducer} initialState={state}>
            <Timeline/>
        </Provider>,
        document.getElementById('app'),
    )
});
