-- Main database creation
CREATE DATABASE VATRefundSystem;
USE VATRefundSystem;

-- Company information table
CREATE TABLE Companies (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    occupation_type VARCHAR(100),
    address TEXT,
    telephone VARCHAR(20),
    fax VARCHAR(20),
    vat_number VARCHAR(20) NOT NULL,
    tin_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- VAT Refund Requests table
CREATE TABLE VATRefundRequests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    request_date DATE NOT NULL,
    refund_month VARCHAR(20) NOT NULL,
    refund_year INT NOT NULL,
    period_from DATE NOT NULL,
    period_to DATE NOT NULL,
    prepared_by VARCHAR(100),
    prepared_signature VARCHAR(255),
    prepared_date DATE,
    approved_by VARCHAR(100),
    approved_signature VARCHAR(255),
    approved_date DATE,
    status ENUM('draft', 'submitted', 'approved', 'rejected', 'processed') DEFAULT 'draft',
    total_vat DECIMAL(15, 2) DEFAULT 0,
    total_wht DECIMAL(15, 2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

-- VAT Entry Details table
CREATE TABLE VATEntries (
    entry_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    entry_number INT NOT NULL,
    reference VARCHAR(50),
    supplier_name VARCHAR(255) NOT NULL,
    supplier_tin VARCHAR(20),
    supplier_vat VARCHAR(20),
    purchase_date DATE NOT NULL,
    invoice_number VARCHAR(50) NOT NULL,
    description TEXT,
    entry_type ENUM('Goods', 'Services') NOT NULL,
    quantity DECIMAL(12, 4) NOT NULL,
    unit_price DECIMAL(15, 4) NOT NULL,
    total_before_vat DECIMAL(15, 2) NOT NULL,
    vat_amount DECIMAL(15, 2) NOT NULL,
    total_after_vat DECIMAL(15, 2) NOT NULL,
    wht_applied ENUM('Yes', 'No') DEFAULT 'No',
    wht_amount DECIMAL(15, 2) DEFAULT 0,
    net_pay DECIMAL(15, 2) NOT NULL,
    wht_number VARCHAR(50),
    payment_method ENUM('Cash', 'Bank', 'Transfer', 'Others'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES VATRefundRequests(request_id)
);

-- VAT Summary table
CREATE TABLE VATSummaries (
    summary_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    accounting_period VARCHAR(50) NOT NULL,
    input_type ENUM('Goods', 'Services') NOT NULL,
    vat_foreign DECIMAL(15, 2) DEFAULT 0,
    vat_general DECIMAL(15, 2) DEFAULT 0,
    vat_local DECIMAL(15, 2) DEFAULT 0,
    vat_total DECIMAL(15, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES VATRefundRequests(request_id)
);

-- Registered List table (could be a view based on VATEntries)
CREATE TABLE RegisteredLists (
    registered_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    entry_number INT NOT NULL,
    reference VARCHAR(50),
    supplier_name VARCHAR(255) NOT NULL,
    purchase_date DATE NOT NULL,
    invoice_number VARCHAR(50) NOT NULL,
    entry_type ENUM('Goods', 'Services') NOT NULL,
    quantity DECIMAL(12, 4) NOT NULL,
    unit_price DECIMAL(15, 4) NOT NULL,
    total_before_vat DECIMAL(15, 2) NOT NULL,
    vat_amount DECIMAL(15, 2) NOT NULL,
    total_after_vat DECIMAL(15, 2) NOT NULL,
    wht_amount DECIMAL(15, 2) DEFAULT 0,
    net_pay DECIMAL(15, 2) NOT NULL,
    payment_method ENUM('Cash', 'Bank', 'Transfer', 'Others'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES VATRefundRequests(request_id)
);

-- Supporting documents table
CREATE TABLE SupportingDocuments (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    document_type ENUM('invoice', 'vat_declaration', 'sales_invoice', 'other') NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    description TEXT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES VATRefundRequests(request_id)
);