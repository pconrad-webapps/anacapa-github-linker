import {Pagination, PaginationItem, PaginationLink} from "reactstrap";
import {observer, inject} from "mobx-react";
import React from "react";
@inject("userStore")
@observer
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
       {[...Array(this.props.userStore.totalPages)].map (
         (page, i) => {
           return(
             <PaginationItem>
             <PaginationLink href="#">
               {i + 1}
             </PaginationLink>
           </PaginationItem>
           )
         }
       )}
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
