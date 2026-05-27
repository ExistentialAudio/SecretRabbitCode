//
//  Extensions.swift
//  SecretRabbitCode
//
//  Created by Devin Roth on 2026-05-26.
//
internal import CSamplerate

extension String {
    init(from errorCode: Int32) {
        self = String(cString: src_strerror(errorCode))
    }
}
