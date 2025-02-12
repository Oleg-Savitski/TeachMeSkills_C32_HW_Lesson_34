package com.teachmeskills.lesson_34.e_library_app.model;

import java.util.Objects;

public final class Book {
    private long id;
    private String title;
    private String author;
    private int publicationYear;

    public Book(long id, String title, String author, int publicationYear) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.publicationYear = publicationYear;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public int getPublicationYear() {
        return publicationYear;
    }

    public void setPublicationYear(int publicationYear) {
        this.publicationYear = publicationYear;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Book book = (Book) o;
        return publicationYear == book.publicationYear && Objects.equals(title, book.title) && Objects.equals(author, book.author);
    }

    @Override
    public int hashCode() {
        return Objects.hash(title, author, publicationYear);
    }

    @Override
    public String toString() {
        return "Book{" +
                "id ->" + id +
                ", title ->'" + title + '\'' +
                ", author ->'" + author + '\'' +
                ", publicationYear ->" + publicationYear +
                '}';
    }
}