package com.teachmeskills.lesson_34.e_library_app.app;

import com.teachmeskills.lesson_34.e_library_app.data.BookData;
import com.teachmeskills.lesson_34.e_library_app.data.ReservationData;
import com.teachmeskills.lesson_34.e_library_app.data.UserData;
import com.teachmeskills.lesson_34.e_library_app.model.Book;
import com.teachmeskills.lesson_34.e_library_app.model.Reservation;
import com.teachmeskills.lesson_34.e_library_app.model.User;

import java.sql.Date;
import java.util.List;
import java.util.logging.Logger;

/**
 * Filled in the table via the console.
 * I checked the program's performance in conjunction
 * with the entire database.
 * Added checks for filling in identical data.
 * I wrapped the functions in SQL queries. All of them are in UTILS.
 * Triggers are weighted on the USERS table.
 * In the runner, you can run a function health check or enter it via a query.
 * List:
 *  - "SELECT * FROM get_all_books()"
 *  - "SELECT * FROM get_last_borrowed_book()"
 *  - "SELECT get_last_registered_user() AS username";
 */

public final class LibraryApp {
    private static final Logger logger = Logger.getLogger(LibraryApp.class.getName());

    public static void main(String[] args) {
        try {
            System.setProperty("java.util.logging.config.file", "src/main/resources/logging.properties");

            //LogManager.getLogManager().readConfiguration();

            UserData userData = new UserData();
            BookData bookData = new BookData();
            ReservationData reservationData = new ReservationData();

            User user = new User(1, "Владимир Немыслемцев", "vovik@mail.ru");
            userData.addUser (user);

            Book book = new Book(1, "Main life", "Неизвестный", 1933);
            bookData.addBook(book);

            Reservation reservation = new Reservation(1, book.getId(), user.getId(), Date.valueOf("2023-02-10"), Date.valueOf("2023-02-12"));
            reservationData.addReservation(reservation);

            String lastUser  = userData.getLastRegisteredUser ();
            System.out.println("The last registered user -> " + lastUser );

            String lastBorrowedBook = reservationData.getLastBorrowedBook();
            System.out.println(lastBorrowedBook);

            List<Book> allBooks = bookData.getAllBooks();
            System.out.println("List of all books:");
            for (Book b : allBooks) {
                System.out.println("ID -> " + b.getId() + ", Title -> " + b.getTitle() + ", Author -> " + b.getAuthor() + ", Year -> " + b.getPublicationYear());
            }

        } catch (Exception e) {
            logger.severe("An error occurred -> " + e.getMessage());
        }
    }
}