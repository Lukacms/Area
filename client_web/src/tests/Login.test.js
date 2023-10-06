import {render, screen} from '@testing-library/react';
import Login from '../pages/Login';

test('test login', () => {
    jest.mock('../pages/Login', () => ({
        useLogin: () => {}
    }))
})
