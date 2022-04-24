using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using Unity.UNetWeaver;
using UnityEngine;
using Votanic.vXR.vGear;

public class DisableRigidBody : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        GetComponent<Rigidbody>().useGravity = false;
        GetComponent<Rigidbody>().isKinematic = true;
        initialRotation = GetComponent<Transform>().rotation;
        Debug.Log(initialRotation);
    }

    public Vector3 snapPosition;
    public Vector3 snapRotation;

    private Quaternion initialRotation;

    public int collidingCount => _collidingCount;


    private int _collidingCount;

    private int _prevCollidingCount;

    public void DisableRigidBodyNow()
    {
        GetComponent<Rigidbody>().useGravity = false;
        GetComponent<Rigidbody>().detectCollisions = true;
        GetComponent<Rigidbody>().isKinematic = true;
    }

    public void EnableRigidBodyNow()
    {
        GetComponent<Rigidbody>().useGravity = false;
        GetComponent<Rigidbody>().detectCollisions = true;
        GetComponent<Rigidbody>().isKinematic = true;
    }

    public void OnVGearCollisionStaying()
    {
        if (_collidingCount <= 50)
        {
            _collidingCount += 5;
        }
    }

    private void Update()
    {
        if (_collidingCount > 0)
        {
            DisableRigidBodyNow();
        }
        else
        {
            EnableRigidBodyNow();
        }

        if (_collidingCount > 0 && !GetComponent<vGear_Interactables>().isGrabbed)
        {
            SnapToPosition();
        }

    }

    private void FixedUpdate()
    {
        if (_collidingCount >= -15)
        {
            _collidingCount -= 3;
        }


        _prevCollidingCount = _collidingCount;
    }

    private void SnapToPosition()
    {
        GetComponent<Transform>().position = snapPosition;
        GetComponent<Transform>().rotation = initialRotation;
    }
}