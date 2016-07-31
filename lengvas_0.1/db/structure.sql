--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auto_listings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE auto_listings (
    id integer NOT NULL,
    source character varying,
    url character varying,
    image_url character varying,
    date character varying,
    listing_id character varying,
    make character varying,
    model character varying,
    vin character varying,
    type character varying,
    year integer,
    fuel_type character varying,
    transmision character varying,
    engine_liters character varying,
    power integer,
    mileage integer,
    mileage_units integer DEFAULT 0,
    price integer,
    price_currency character varying DEFAULT 'euro'::character varying,
    city character varying,
    country character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: auto_listings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE auto_listings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auto_listings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE auto_listings_id_seq OWNED BY auto_listings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY auto_listings ALTER COLUMN id SET DEFAULT nextval('auto_listings_id_seq'::regclass);


--
-- Name: auto_listings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY auto_listings
    ADD CONSTRAINT auto_listings_pkey PRIMARY KEY (id);


--
-- Name: index_auto_listings_on_listing_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_auto_listings_on_listing_id ON auto_listings USING btree (listing_id);


--
-- Name: index_auto_listings_on_make; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_auto_listings_on_make ON auto_listings USING btree (make);


--
-- Name: index_auto_listings_on_mileage; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_auto_listings_on_mileage ON auto_listings USING btree (mileage);


--
-- Name: index_auto_listings_on_model; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_auto_listings_on_model ON auto_listings USING btree (model);


--
-- Name: index_auto_listings_on_price; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_auto_listings_on_price ON auto_listings USING btree (price);


--
-- Name: index_auto_listings_on_source; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_auto_listings_on_source ON auto_listings USING btree (source);


--
-- Name: index_auto_listings_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_auto_listings_on_type ON auto_listings USING btree (type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public, postgis;

INSERT INTO schema_migrations (version) VALUES ('0');

INSERT INTO schema_migrations (version) VALUES ('20160731191958');

