package com.teachmeskills.lesson_34.e_library_app.model;

import java.util.Date;
import java.util.Objects;

public final class Reservation {
    private long id;
    private long bookId;
    private long usernameId;
    private Date reservationDate;
    private Date returnDate;

    public Reservation(long id, long bookId, long usernameId, Date reservationDate, Date returnDate) {
        this.id = id;
        this.bookId = bookId;
        this.usernameId = usernameId;
        this.reservationDate = reservationDate;
        this.returnDate = returnDate;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getBookId() {
        return bookId;
    }

    public void setBookId(long bookId) {
        this.bookId = bookId;
    }

    public long getUsernameId() {
        return usernameId;
    }

    public void setUsernameId(long usernameId) {
        this.usernameId = usernameId;
    }

    public Date getReservationDate() {
        return reservationDate;
    }

    public void setReservationDate(Date reservationDate) {
        this.reservationDate = reservationDate;
    }

    public Date getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Date returnDate) {
        this.returnDate = returnDate;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Reservation that = (Reservation) o;
        return bookId == that.bookId && usernameId == that.usernameId && Objects.equals(returnDate, that.returnDate);
    }

    @Override
    public int hashCode() {
        return Objects.hash(bookId, usernameId, returnDate);
    }

    @Override
    public String toString() {
        return "Reservation{" +
                "id ->" + id +
                ", bookId ->" + bookId +
                ", usernameId ->" + usernameId +
                ", reservationDate ->" + reservationDate +
                ", returnDate ->" + returnDate +
                '}';
    }
}