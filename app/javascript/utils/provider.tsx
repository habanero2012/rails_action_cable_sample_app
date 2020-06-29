import React, {FC, createContext, useContext, useReducer} from 'react';

const StateContext = createContext({});
export const useStateContext = () => useContext(StateContext);

const DispatchContext = createContext((action:any) => {});
export const useDispatchContext = () => useContext(DispatchContext);


const Provider: FC<{reducer, initialState}> = ({reducer, initialState, children}) => {
    const [state, dispatch] = useReducer(reducer, initialState);
    return (
        <StateContext.Provider value={state}>
            <DispatchContext.Provider value={dispatch}>
                {children}
            </DispatchContext.Provider>
        </StateContext.Provider>
    )
};

export default Provider;