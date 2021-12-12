import * as React from 'react';
import ToggleButton from '@mui/material/ToggleButton';
import ToggleButtonGroup from '@mui/material/ToggleButtonGroup';
import Typography from '@mui/material/Typography';
import Paper from '@mui/material/Paper';
import { createTheme, ThemeProvider, styled } from '@mui/material/styles';
import Grid from '@mui/material/Grid';
const Item = styled(ToggleButton)(({ theme }) => ({
    ...theme.typography.body2,
    textAlign: 'left',
    width: '200px',
}));
const StyledPaper = styled(Paper)(({ theme }) => ({
    ...theme.typography.body2,
    textAlign: 'left',
    paddingLeft: 10,
    paddingTop: 10,
    color: theme.palette.text.secondary,
    lineHeight: '60px',
    width: '93%',
    height: '30vh'
}));
export default function Buy() {
    const [alignment, setAlignment] = React.useState('buy');

    const handleChange = (event, newAlignment) => {
        setAlignment(newAlignment);
    };

    return (
        <Grid container direction="column" mt="10vh" pl="6vw">
            <ToggleButtonGroup
                // color="standard"

                value={alignment}
                exclusive
                onChange={handleChange}
            >
                <Item value="buy">Buy</Item>
                <Item value="sell">Sell</Item>
            </ToggleButtonGroup>
            {alignment == 'buy' ?
                <Grid container>
                    <StyledPaper>
                        <Grid container>
                            Buy
                        </Grid>
                    </StyledPaper>
                </Grid>
                :
                <Grid>
                    <Typography>sell</Typography>
                </Grid>
            }
        </Grid>


    );
}
