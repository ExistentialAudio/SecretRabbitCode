//
//  SecretRabbitCodeError.swift
//  SecretRabbitCode
//
//  Created by Devin Roth on 2026-05-26.
//
internal import CSamplerate

public enum SecretRabbitCodeError: Error {
    case initalizationFailed(description: String)
    case conversionFailed(description: String)
    case unusedInputFrames
}

extension SecretRabbitCodeError: Equatable { }

extension SecretRabbitCodeError: Hashable { }

extension SecretRabbitCodeError: Sendable { }
