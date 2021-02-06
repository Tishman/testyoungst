//
//  DatabaseService.swift
//  YoungSt
//
//  Created by tichenko.r on 23.12.2020.
//

import Foundation
import GRDB
import Combine

typealias DatabaseModelProtocol = Codable & FetchableRecord & PersistableRecord

protocol DatabaseServiceProtocol {
	func save<T: DatabaseModelProtocol>(_ value: T) -> AnyPublisher<Void, Error>
	func fetchAll<T: DatabaseModelProtocol>() -> AnyPublisher<[T], Error>
	func deleteAll<T: DatabaseModelProtocol>(_ type: T.Type) -> AnyPublisher<Void, Error>
}

final class DatabaseService: DatabaseServiceProtocol {
	
	private let dbQueue: DatabaseQueue
	
	private var migrator: DatabaseMigrator {
		var migrator = DatabaseMigrator()
		#if DEBUG
		// Speed up development by nuking the database when migrations change
		// See https://github.com/groue/GRDB.swift/blob/master/Documentation/Migrations.md#the-erasedatabaseonschemachange-option
		migrator.eraseDatabaseOnSchemaChange = true
		#endif
		migrator.registerMigration(DatabaseVersion.v1.rawValue) { db in
			try db.create(table: "\(WordDBModel.self)", body: { table in
				table.column("id").primaryKey().notNull()
				table.column("sourceText", .text).notNull()
				table.column("destinationText", .text).notNull()
			})
		}
		return migrator
	}
	
	init(_ dbQueue: DatabaseQueue) throws {
		self.dbQueue = dbQueue
		try migrator.migrate(dbQueue)
	}
	
	func save<T: DatabaseModelProtocol>(_ value: T) -> AnyPublisher<Void, Error> {
		return dbQueue.writePublisher { db in
			try value.insert(db)
		}
		.eraseToAnyPublisher()
	}
	
	func fetchAll<T: DatabaseModelProtocol>() -> AnyPublisher<[T], Error> {
		return dbQueue.readPublisher { db in
			try T.fetchAll(db)
		}
		.eraseToAnyPublisher()
	}
	
	func deleteAll<T: DatabaseModelProtocol>(_ type: T.Type) -> AnyPublisher<Void, Error> {
		return dbQueue.writePublisher { db in
			try type.deleteAll(db)
		}
		.eraseToAnyPublisher()
	}
}
