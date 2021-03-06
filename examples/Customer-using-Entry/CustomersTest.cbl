identification division.
program-id. CustomersTest.

environment division.
configuration section.
    repository.
        function all intrinsic.

data division.
working-storage section.
copy Customer replacing Customer by CustomerExpected.
copy Customer replacing Customer by CustomerReturned.

01 FirstCustomerId  pic 9(4).
01 SecondCustomerId pic 9(4).
01 TempCustomerId   pic 9(4).
01 NumberOfCustomersReturned pic 9(4).
01 CustomersFileName pic x(20) value spaces.

procedure division.

SetupInitialData.
    move "Foobar Widgets" to Name of CustomerExpected
    move "123 High Street" to Address1 of CustomerExpected
    move "Somewhere" to City of CustomerExpected
    move "SW1 8QT" to Postcode of CustomerExpected
    move "01234567890" to Telephone of CustomerExpected
    move "07123456789" to Mobile of CustomerExpected
    move "Micky Mouse" to Contact of CustomerExpected.

LikeAnObjectInstantiation.
    call "Customers".

InitialiseCustomersFile.
    move "Clientes.dat" to CustomersFileName
    call "SetCustomerFileName" using CustomersFileName.

TestCanAddACustomer.
    *> Given
    call "AddCustomer" using by content CustomerExpected, by reference FirstCustomerId

    *> When
    call "GetCustomerById" using by reference CustomerReturned, by content FirstCustomerId

    *> Then
    call "AssertEquals" using by content CustomerReturned, by content CustomerExpected
        by content "Result returns the correct details for first customer".

    *> When
    call "GetCustomerIdByName" using by content CustomerExpected, by reference TempCustomerId

    *> Then
    call "AssertEquals" using by content TempCustomerId, by content FirstCustomerId,
        concatenate("Successfully returned 1st id of ", FirstCustomerId).

TestCanAddAnotherCustomer.
    *> Given
    move "Donald Duck" to Contact of CustomerExpected
    move "Snafu Snacks Ltd" to Name of CustomerExpected
    call "AddCustomer" using by content CustomerExpected, by reference SecondCustomerId

    *> When
    call "GetCustomerById" using by reference CustomerReturned, by content SecondCustomerId

    *> Then
    call "AssertEquals" using by content CustomerReturned, by content CustomerExpected
        by content "Result returns the correct details for 2nd customer".

    *> When
    call "GetCustomerIdByName" using by content CustomerExpected, by reference TempCustomerId

    *> Then
    call "AssertEquals" using by content TempCustomerId, by content SecondCustomerId,
        concatenate("Successfully returned 2nd id of ", SecondCustomerId).

TestFirstCustomerExistsStill.
    *> Given
    move "Foobar Widgets" to Name of CustomerExpected
    move "Micky Mouse" to Contact of CustomerExpected

    *> When
    call "GetCustomerIdByName" using by content CustomerExpected, by reference TempCustomerId

    *> Then
    call "AssertEquals" using by content TempCustomerId, by content FirstCustomerId,
        concatenate("Successfully returned 1st id of ", FirstCustomerId).

TestCustomerDetailsCanBeUpdated.
    *> Given
    move "Foobar Widgets Limited" to Name of CustomerExpected
    call "UpdateCustomerById" using by content CustomerExpected, by content FirstCustomerId

    *> When
    call "GetCustomerIdByName" using by content CustomerExpected, by reference TempCustomerId

    *> Then
    call "AssertEquals" using by content TempCustomerId,  by content FirstCustomerId,
        concatenate("Successfully returned 1st id of ", FirstCustomerId).

TestNumberOfCustomersIsTwo.
    *> Given/When
    call "GetNumberOfCustomers" using by reference NumberOfCustomersReturned

    *> Then
    call "AssertEquals" using by content NumberOfCustomersReturned,
        by content 2, "Number of customers returned is 2".

TestCustomerCanBeDeleted.
    *> Given
    call "DeleteCustomerById" using by content FirstCustomerId

    *> When
    call "GetCustomerIdByName" using by content CustomerExpected, by reference TempCustomerId

    *> Then
    call "AssertNotEquals" using by content TempCustomerId, by content FirstCustomerId,
        concatenate("Delete successful, id no longer exists").

TestNumberOfCustomersIsOne.
    *> Given/When
    call "GetNumberOfCustomers" using by reference NumberOfCustomersReturned

    *> Then
    call "AssertEquals" using by content NumberOfCustomersReturned,
        by content 1, "Number of customers returned is 1".

    stop run.

end program CustomersTest.
