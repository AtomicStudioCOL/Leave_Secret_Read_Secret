/*

    Copyright (c) 2024 Pocketz World. All rights reserved.

    This is a generated file, do not edit!

    Generated by com.pz.studio
*/

#if UNITY_EDITOR

using System;
using System.Linq;
using UnityEngine;
using Highrise.Client;

namespace Highrise.Lua.Generated
{
    [AddComponentMenu("Lua/ReportSecret")]
    [LuaBehaviourScript(s_scriptGUID)]
    public class ReportSecret : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "d0a3a44ffd3b35641b47c0a3bf4db184";
        public override string ScriptGUID => s_scriptGUID;


        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), null),
                CreateSerializedProperty(_script.GetPropertyAt(1), null),
                CreateSerializedProperty(_script.GetPropertyAt(2), null),
                CreateSerializedProperty(_script.GetPropertyAt(3), null),
                CreateSerializedProperty(_script.GetPropertyAt(4), null),
                CreateSerializedProperty(_script.GetPropertyAt(5), null),
                CreateSerializedProperty(_script.GetPropertyAt(6), null),
                CreateSerializedProperty(_script.GetPropertyAt(7), null),
            };
        }
    }
}

#endif
