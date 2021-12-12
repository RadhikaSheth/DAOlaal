import * as React from 'react';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import Grid from '@mui/material/Grid';
import Typography from '@mui/material/Typography';

import { createTheme, ThemeProvider, styled } from '@mui/material/styles';
function createData(Name, OraclePrice, TerraswapPrice, Difference) {
    return { Name, OraclePrice, TerraswapPrice, Difference };
}

const StyledText = styled(Typography)(() => ({
    color: 'rgba(255, 255, 255, 0.7)'
}))

export default function Trade({mintSymbol, price}) {
    const [swapPrice, setPrice] = React.useState(2452);   
    const rows = [
        createData(mintSymbol, price, swapPrice, price-swapPrice),
    ]; 
    return (
        <Grid mt="10vh" container pl="6vw">
            <StyledText variant="h4" pb={1}>
                Price
            </StyledText>
            <TableContainer component={Paper} style={{ width: '85vw' }}>
                <Table sx={{ minWidth: '80vw' }} aria-label="simple table">
                    <TableHead>
                        <TableRow>
                            <TableCell><StyledText variant='h6' fontWeight="bold">Symbol</StyledText></TableCell>
                            <TableCell align="right"><StyledText variant='h6' fontWeight="bold">Oracle Price</StyledText></TableCell>
                            <TableCell align="right"><StyledText variant='h6' fontWeight="bold">Swap     Price</StyledText></TableCell>
                            <TableCell align="right"><StyledText variant='h6' fontWeight="bold">Difference</StyledText></TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map((row) => (
                            <TableRow
                                hover
                                key={row.name}
                                sx={{ '&:last-child td, &:last-child th': { border: 0 } }}
                            >
                                <TableCell component="th" scope="row">
                                    <StyledText>{row.Name}</StyledText>
                                </TableCell>
                                <TableCell align="right"><StyledText>{row.OraclePrice} &nbsp; INR</StyledText></TableCell>
                                <TableCell align="right"><StyledText>{row.TerraswapPrice} &nbsp; INR</StyledText></TableCell>
                                <TableCell align="right"><StyledText>{row.Difference} &nbsp; INR</StyledText></TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            </TableContainer>
        </Grid>

    );
}
