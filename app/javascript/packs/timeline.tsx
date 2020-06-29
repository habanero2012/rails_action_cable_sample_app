import React from 'react'
import ReactDOM from 'react-dom'

import Timeline from "../container/timeline";
import Provider from "../utils/provider";

import reducer, {initialState} from "../reducers/timeline";

document.addEventListener('DOMContentLoaded', () => {
    const app = document.getElementById('app');
    const microposts = JSON.parse(app.getAttribute('data-microposts'));
    const loginId = JSON.parse(app.getAttribute('data-login-id'));

    ReactDOM.render(
        <Provider reducer={reducer} initialState={{microposts, loginId}}>
            <Timeline/>
        </Provider>,
        document.getElementById('app'),
    )
});
