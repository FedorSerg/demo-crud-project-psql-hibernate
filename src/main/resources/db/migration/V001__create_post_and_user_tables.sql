DO
$$
    DECLARE
        scriptName VARCHAR := 'Create tables for persons and posts';
    BEGIN
        RAISE NOTICE 'Start of % ...', scriptName;

        CREATE TABLE IF NOT EXISTS person
        (
            id    BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
            login TEXT NOT NULL
        );
        CREATE UNIQUE INDEX IF NOT EXISTS ui_person_login ON person (login);
        COMMENT ON TABLE person IS 'Users info table';
        COMMENT ON COLUMN person.id IS 'Unique autoincrement identification number';
        COMMENT ON COLUMN person.login IS 'Unique person login';

        CREATE TABLE IF NOT EXISTS post
        (
            id        BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
            title     TEXT   NOT NULL,
            body      TEXT   NOT NULL,
            author_id BIGINT NOT NULL
                CONSTRAINT post_author_id_ref REFERENCES person
        );
        CREATE INDEX IF NOT EXISTS i_post_author_id ON post (author_id);
        COMMENT ON TABLE post IS 'Information posts table';
        COMMENT ON COLUMN post.id IS 'Unique autoincrement identification number';
        COMMENT ON COLUMN post.title IS 'Title of the post';
        COMMENT ON COLUMN post.body IS 'Main text message of the post';
        COMMENT ON COLUMN post.author_id IS 'Unique ID of the post author, see "USER" table';

        CREATE TABLE IF NOT EXISTS post_likes
        (
            post_id   BIGINT NOT NULL
                CONSTRAINT post_likes_post_id_ref REFERENCES post,
            person_id BIGINT NOT NULL
                CONSTRAINT post_likes_person_id_ref REFERENCES person,
            PRIMARY KEY (post_id, person_id)
        );
        COMMENT ON TABLE post_likes IS 'Table with information about which person liked which post, has composite primary key';
        COMMENT ON COLUMN post_likes.post_id IS 'Unique ID of the liked post, see POST table';
        COMMENT ON COLUMN post_likes.person_id IS 'Unique ID of the person that liked the post, see "USER" table';

        CREATE TABLE IF NOT EXISTS person_subscriptions
        (
            person_id       BIGINT NOT NULL
                CONSTRAINT person_subscriptions_person_id_ref REFERENCES person,
            subscription_id BIGINT NOT NULL
                CONSTRAINT person_subscriptions_subscription_id_ref REFERENCES person,
            PRIMARY KEY (person_id, subscription_id)
        );
        COMMENT ON TABLE person_subscriptions IS 'Table with information about which person subscribed to which person, has composite primary key';
        COMMENT ON COLUMN person_subscriptions.person_id IS 'Unique ID of the person that subscribed to another person, see "USER" table';
        COMMENT ON COLUMN person_subscriptions.subscription_id IS 'Unique ID of the followed person, see "USER" table';
    END
$$
