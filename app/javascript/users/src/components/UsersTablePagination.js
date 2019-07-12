import {Pagination, PaginationItem, PaginationLink} from "reactstrap";
import React from "react";
 export default class UsersTablePagination extends React.Component {


   render() {
     return(
       <Pagination aria-label="Page navigation example">
       <PaginationItem>
         <PaginationLink first href="#" />
       </PaginationItem>
       <PaginationItem>
         <PaginationLink previous href="#" />
       </PaginationItem>
       start loop
       <PaginationItem>
         <PaginationLink href="#">
           page number goes here
         </PaginationLink>
       </PaginationItem>
       end loop

       <PaginationItem>
         <PaginationLink next href="#" />
       </PaginationItem>
       <PaginationItem>
         <PaginationLink last href="#" />
       </PaginationItem>
     </Pagination>
     )
   }
 }
